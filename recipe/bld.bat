@echo on
set "TCLDIR=%BUILD_PREFIX%\Library"

:: Define common options
set OPTIONS=-DSQLITE_DQS=3 ^
            -DSQLITE_ENABLE_COLUMN_METADATA ^
            -DSQLITE_ENABLE_DBSTAT_VTAB ^
            -DSQLITE_ENABLE_DESERIALIZE ^
            -DSQLITE_ENABLE_EXPLAIN_COMMENTS ^
            -DSQLITE_ENABLE_FTS3 ^
            -DSQLITE_ENABLE_FTS3_PARENTHESIS ^
            -DSQLITE_ENABLE_FTS3_TOKENIZER ^
            -DSQLITE_ENABLE_FTS4 ^
            -DSQLITE_ENABLE_FTS5 ^
            -DSQLITE_ENABLE_GEOPOLY ^
            -DSQLITE_ENABLE_JSON1 ^
            -DSQLITE_ENABLE_MATH_FUNCTIONS ^
            -DSQLITE_ENABLE_PREUPDATE_HOOK ^
            -DSQLITE_ENABLE_RTREE ^
            -DSQLITE_ENABLE_SESSION ^
            -DSQLITE_ENABLE_STAT4 ^
            -DSQLITE_ENABLE_STMTVTAB ^
            -DSQLITE_ENABLE_UNLOCK_NOTIFY ^
            -DSQLITE_ENABLE_UPDATE_DELETE_LIMIT ^
            -DSQLITE_LIKE_DOESNT_MATCH_BLOBS ^
            -DSQLITE_MAX_EXPR_DEPTH=10000 ^
            -DSQLITE_MAX_VARIABLE_NUMBER=250000 ^
            -DSQLITE_SOUNDEX ^
            -DSQLITE_STRICT_SUBTYPE=1 ^
            -DSQLITE_THREADSAFE=1 ^
            -DSQLITE_USE_URI ^
            -DHAVE_ISNAN

:: Build DLL and shell executable
nmake /f Makefile.msc DYNAMIC_SHELL=1 ^
                      USE_NATIVE_LIBPATHS=1 ^
                      TCLDIR=%TCLDIR% ^
                      OPT_FEATURE_FLAGS="%OPTIONS%"
if %ERRORLEVEL% neq 0 exit 1


COPY sqlite3.exe  %LIBRARY_BIN% || exit 1
COPY sqlite3.dll  %LIBRARY_BIN% || exit 1
COPY sqlite3.lib  %LIBRARY_LIB% || exit 1
COPY sqlite3.h    %LIBRARY_INC% || exit 1
COPY sqlite3ext.h %LIBRARY_INC% || exit 1

:: build sqldiff
nmake /f Makefile.msc sqldiff.exe TCLDIR=%TCLDIR% OPT_FEATURE_FLAGS="%OPTIONS%"
if %ERRORLEVEL% neq 0 exit 1

:: build sqlite3_rsync
nmake /f Makefile.msc sqlite3_rsync.exe TCLDIR=%TCLDIR% OPT_FEATURE_FLAGS="%OPTIONS%"
if %ERRORLEVEL% neq 0 exit 1

:: build sqlite3_analyzer
nmake /f Makefile.msc STATICALLY_LINK_TCL=0 sqlite3_analyzer.exe TCLDIR=%TCLDIR% OPT_FEATURE_FLAGS="%OPTIONS%"
if %ERRORLEVEL% neq 0 exit 1

COPY sqldiff.exe %LIBRARY_BIN% || exit 1
COPY sqlite3_rsync.exe %LIBRARY_BIN% || exit 1
COPY sqlite3_analyzer.exe %LIBRARY_BIN%\sqlite3_analyze.exe || exit 1
