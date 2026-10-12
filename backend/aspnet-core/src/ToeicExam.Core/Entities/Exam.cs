using Abp.Domain.Entities;

namespace ToeicExam.Entities
{
    public class Exam : Entity<int>
    {
        public string Title { get; set; }
        public int Duration { get; set; } = 75; // 75 phút
        public int TotalQuestions { get; set; }
    }
}