use 5.008008;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'Log::Lite',
    VERSION_FROM      => 'lib/Log/Lite.pm', 
    PREREQ_PM         => {
                           'File::Path' => 2.09,
                         }, 
    ($] >= 5.005 ?     
      (ABSTRACT_FROM  => 'lib/Log/Lite.pm', 
       AUTHOR         => '陈 钢 <yikuyiku.com@gmail.com>') : ()),
);
