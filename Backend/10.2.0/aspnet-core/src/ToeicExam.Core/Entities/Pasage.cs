using Abp.Domain.Entities;

namespace ToeicExam.Entities
{
    public class Passage : Entity<int>
    {
        public int ExamId { get; set; }
        public string Content { get; set; }
    }
}