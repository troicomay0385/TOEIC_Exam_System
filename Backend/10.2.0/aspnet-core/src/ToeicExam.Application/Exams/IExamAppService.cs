using System.Collections.Generic;
using System.Threading.Tasks;
using Abp.Application.Services;
using Microsoft.AspNetCore.Http;

namespace ToeicExam.Exams
{
    public interface IExamAppService : IApplicationService
    {
        Task<List<ExamDto>> GetAllExamsAsync();
        Task<ExamDto> GetExamDetailAsync(int examId);
        Task<string> ImportExamFromDocxAsync(IFormFile file);
    }
}