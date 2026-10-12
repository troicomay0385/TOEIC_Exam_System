using Abp.Zero.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using ToeicExam.Authorization.Roles;
using ToeicExam.Authorization.Users;
using ToeicExam.Entities;
using ToeicExam.MultiTenancy;

namespace ToeicExam.EntityFrameworkCore;

public class ToeicExamDbContext : AbpZeroDbContext<Tenant, Role, User, ToeicExamDbContext>
{
    /* Define a DbSet for each entity of the application */
    public DbSet<Exam> Exams { get; set; }
    public DbSet<Passage> Passages { get; set; }
    public DbSet<Question> Questions { get; set; }
    public DbSet<Option> Options { get; set; }
    public ToeicExamDbContext(DbContextOptions<ToeicExamDbContext> options)
        : base(options)
    {
    }
}
