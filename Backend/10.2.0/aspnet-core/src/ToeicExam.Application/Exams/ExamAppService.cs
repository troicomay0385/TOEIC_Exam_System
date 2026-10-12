using Abp.Application.Services;
using Abp.Domain.Repositories;
using Abp.UI;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using ToeicExam.Entities;

namespace ToeicExam.Exams
{
    public class ExamAppService : ApplicationService, IExamAppService
    {
        private readonly IRepository<Exam, int> _examRepository;
        private readonly IRepository<Passage, int> _passageRepository;
        private readonly IRepository<Question, int> _questionRepository;
        private readonly IRepository<Option, int> _optionRepository;

        public ExamAppService(
            IRepository<Exam, int> examRepository,
            IRepository<Passage, int> passageRepository,
            IRepository<Question, int> questionRepository,
            IRepository<Option, int> optionRepository)
        {
            _examRepository = examRepository;
            _passageRepository = passageRepository;
            _questionRepository = questionRepository;
            _optionRepository = optionRepository;
        }

        public async Task<List<ExamDto>> GetAllExamsAsync()
        {
            var exams = await _examRepository.GetAllListAsync();
            var result = new List<ExamDto>();

            foreach (var exam in exams)
            {
                var questionCount = await _questionRepository.CountAsync(q => q.ExamId == exam.Id);
                result.Add(new ExamDto
                {
                    Id = exam.Id,
                    Title = exam.Title,
                    Duration = exam.Duration,
                    TotalQuestions = questionCount
                });
            }

            return result;
        }

        public async Task<ExamDto> GetExamDetailAsync(int examId)
        {
            var exam = await _examRepository.GetAsync(examId);
            var questions = await _questionRepository.GetAll()
                .Where(q => q.ExamId == examId)
                .OrderBy(q => q.QuestionNumber)
                .ToListAsync();

            var examDto = new ExamDto
            {
                Id = exam.Id,
                Title = exam.Title,
                Duration = exam.Duration,
                TotalQuestions = questions.Count
            };

            foreach (var q in questions)
            {
                string passageContent = null;
                if (q.PassageId.HasValue)
                {
                    var passage = await _passageRepository.FirstOrDefaultAsync(q.PassageId.Value);
                    passageContent = passage?.Content;
                }

                var options = await _optionRepository.GetAllListAsync(o => o.QuestionId == q.Id);

                examDto.Questions.Add(new QuestionDto
                {
                    Id = q.Id,
                    QuestionNumber = q.QuestionNumber,
                    Content = q.Content,
                    CorrectAnswer = q.CorrectAnswer,
                    PassageContent = passageContent,
                    Options = options.Select(o => new OptionDto { Label = o.Label, Content = o.Content }).ToList()
                });
            }

            return examDto;
        }

        public async Task<string> ImportExamFromDocxAsync(IFormFile file)
        {
            if (file == null || file.Length == 0)
                throw new UserFriendlyException("File không hợp lệ hoặc bị rỗng!");

            var lines = new List<string>();

            using (var stream = file.OpenReadStream())
            using (var wordDoc = WordprocessingDocument.Open(stream, false))
            {
                var body = wordDoc.MainDocumentPart.Document.Body;
                foreach (var paragraph in body.Elements<Paragraph>())
                {
                    var text = paragraph.InnerText?.Trim();
                    if (!string.IsNullOrWhiteSpace(text))
                    {
                        lines.Add(text);
                    }
                }
            }

            // Parse & Validate
            string examTitle = "Đề thi TOEIC";

            // Lấy Title
            var titleLine = lines.FirstOrDefault(l => l.StartsWith("[EXAM_TITLE]:"));
            if (titleLine != null)
            {
                examTitle = titleLine.Replace("[EXAM_TITLE]:", "").Trim();
            }

            // Tiến hành lưu
            var newExam = await _examRepository.InsertAsync(new Exam
            {
                Title = examTitle,
                Duration = 75,
                TotalQuestions = 0
            });
            await CurrentUnitOfWork.SaveChangesAsync();

            int? currentPassageId = null;
            string currentPassageText = "";
            bool inPassage = false;

            Question currentQuestion = null;
            var currentOptions = new List<Option>();

            for (int i = 0; i < lines.Count; i++)
            {
                var line = lines[i];

                if (line.StartsWith("[PASSAGE_START]"))
                {
                    inPassage = true;
                    currentPassageText = "";
                    continue;
                }

                if (line.StartsWith("[PASSAGE_END]"))
                {
                    inPassage = false;
                    var passage = await _passageRepository.InsertAsync(new Passage
                    {
                        ExamId = newExam.Id,
                        Content = currentPassageText.Trim()
                    });
                    await CurrentUnitOfWork.SaveChangesAsync();
                    currentPassageId = passage.Id;
                    continue;
                }

                if (inPassage)
                {
                    currentPassageText += line + "\n";
                    continue;
                }

                if (line.StartsWith("[PART5]"))
                {
                    currentPassageId = null;
                    continue;
                }

                if (line.StartsWith("[QUESTION]"))
                {
                    if (currentQuestion != null)
                    {
                        await SaveQuestionAndOptions(currentQuestion, currentOptions);
                        currentOptions.Clear();
                    }

                    var qText = line.Replace("[QUESTION]", "").Trim();
                    int qNum = 0;

                    var parts = qText.Split('.');
                    if (parts.Length > 0 && int.TryParse(parts[0].Trim(), out int parsedNum))
                    {
                        qNum = parsedNum;
                        qText = string.Join(".", parts.Skip(1)).Trim();
                    }

                    currentQuestion = new Question
                    {
                        ExamId = newExam.Id,
                        PassageId = currentPassageId,
                        QuestionNumber = qNum,
                        Content = qText,
                        CorrectAnswer = "A"
                    };
                    continue;
                }

                if (line.StartsWith("[A]"))
                {
                    currentOptions.Add(new Option { Label = "A", Content = line.Replace("[A]", "").Trim() });
                }
                else if (line.StartsWith("[B]"))
                {
                    currentOptions.Add(new Option { Label = "B", Content = line.Replace("[B]", "").Trim() });
                }
                else if (line.StartsWith("[C]"))
                {
                    currentOptions.Add(new Option { Label = "C", Content = line.Replace("[C]", "").Trim() });
                }
                else if (line.StartsWith("[D]"))
                {
                    currentOptions.Add(new Option { Label = "D", Content = line.Replace("[D]", "").Trim() });
                }
                else if (line.StartsWith("[ANSWER]"))
                {
                    if (currentQuestion != null)
                    {
                        currentQuestion.CorrectAnswer = line.Replace("[ANSWER]", "").Trim();
                    }
                }
            }

            if (currentQuestion != null)
            {
                await SaveQuestionAndOptions(currentQuestion, currentOptions);
            }

            return $"Import thành công đề thi: {examTitle}";
        }

        private async Task SaveQuestionAndOptions(Question question, List<Option> options)
        {
            var savedQuestion = await _questionRepository.InsertAsync(question);
            await CurrentUnitOfWork.SaveChangesAsync();

            foreach (var opt in options)
            {
                opt.QuestionId = savedQuestion.Id;
                await _optionRepository.InsertAsync(opt);
            }
            await CurrentUnitOfWork.SaveChangesAsync();
        }
    }
}