use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'ServerControl-Dcc',
   VERSION_FROM => 'lib/ServerControl/Module/Dcc.pm',
   PREREQ_PM => {'ServerControl' => '0.100'},
   LICENSE => 'bsd'
);

