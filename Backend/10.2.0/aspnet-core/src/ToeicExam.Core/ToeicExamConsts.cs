using ToeicExam.Debugging;

namespace ToeicExam;

public class ToeicExamConsts
{
    public const string LocalizationSourceName = "ToeicExam";

    public const string ConnectionStringName = "Default";

    public const bool MultiTenancyEnabled = true;


    /// <summary>
    /// Default pass phrase for SimpleStringCipher decrypt/encrypt operations
    /// </summary>
    public static readonly string DefaultPassPhrase =
        DebugHelper.IsDebug ? "gsKxGZ012HLL3MI5" : "60aa010136bc4ecea171b90c26c0c18d";
}
