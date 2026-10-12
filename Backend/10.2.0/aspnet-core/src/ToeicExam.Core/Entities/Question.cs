using Abp.Domain.Entities;

namespace ToeicExam.Entities
{
    public class Question : Entity<int>
    {
        public int ExamId { get; set; }
        public int? PassageId { get; set; } // Nullable nếu là câu hỏi độc lập (Part 5)
        public int QuestionNumber { get; set; }
        public string Content { get; set; }
        public string CorrectAnswer { get; set; } // A, B, C, D
    }
}