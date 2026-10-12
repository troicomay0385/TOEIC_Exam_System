using System.Collections.Generic;
using Abp.Application.Services.Dto;

namespace ToeicExam.Exams
{
    public class ExamDto : EntityDto<int>
    {
        public string Title { get; set; }
        public int Duration { get; set; }
        public int TotalQuestions { get; set; }
        public List<QuestionDto> Questions { get; set; } = new List<QuestionDto>();
    }

    public class QuestionDto : EntityDto<int>
    {
        public int QuestionNumber { get; set; }
        public string Content { get; set; }
        public string CorrectAnswer { get; set; }
        public string PassageContent { get; set; }
        public List<OptionDto> Options { get; set; } = new List<OptionDto>();
    }

    public class OptionDto
    {
        public string Label { get; set; }
        public string Content { get; set; }
    }

    public class UploadExamInput
    {
        public string Title { get; set; }
    }
}