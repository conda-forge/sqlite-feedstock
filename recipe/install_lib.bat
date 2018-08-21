COPY sqlite3.dll %LIBRARY_BIN% || exit 1
COPY sqlite3.lib %LIBRARY_LIB% || exit 1
COPY sqlite3.h   %LIBRARY_INC% || exit 1

