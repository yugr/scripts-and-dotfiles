set history save on
set print pretty on
set pagination off
set confirm off

# Skip STL source files
# (from https://stackoverflow.com/questions/6219223/can-i-prevent-debugger-from-stepping-into-boost-or-stl-header-files)
define skipstl
python
# get all sources loadable by gdb
def GetSources():
    sources = []
    for line in gdb.execute('info sources',to_string=True).splitlines():
        if line.startswith("/"):
            sources += [source.strip() for source in line.split(",")]
    return sources

# skip files of which the (absolute) path begins with 'dir'
def SkipDir(dir):
    sources = GetSources()
    for source in sources:
        if source.startswith(dir):
            gdb.execute('skip file %s' % source, to_string=True)

# apply only for c++
if 'c++' in gdb.execute('show language', to_string=True):
    SkipDir("/usr")
end
end
