using Abp.Domain.Entities;

namespace ToeicExam.Entities
{
    public class Option : Entity<int>
    {
        public int QuestionId { get; set; }
        public string Label { get; set; } // A, B, C, D
        public string Content { get; set; }
    }
}