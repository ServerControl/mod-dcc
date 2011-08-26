#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package ServerControl::Module::Dcc;

use strict;
use warnings;

our $VERSION = '0.94';

use ServerControl::Module;
use ServerControl::Commons::Process;

use base qw(ServerControl::Module);

__PACKAGE__->Implements( qw(ServerControl::Module::PidFile) );

__PACKAGE__->Parameter(
   help  => { isa => 'bool', call => sub { __PACKAGE__->help; } },
);

sub help {
   my ($class) = @_;

   print __PACKAGE__ . " " . $ServerControl::Module::Dcc::VERSION . "\n";

   printf "  %-30s%s\n", "--name=", "Instance Name";
   printf "  %-30s%s\n", "--path=", "The path where the instance should be created";
   print "\n";
   printf "  %-30s%s\n", "--create", "Create the instance";
   printf "  %-30s%s\n", "--start", "Start the instance";
   printf "  %-30s%s\n", "--stop", "Stop the instance";

}

sub start {
   my ($class) = @_;

   my ($name, $path) = ($class->get_name, $class->get_path);
   my $pid_dir       = ServerControl::FsLayout->get_directory("Runtime", "pid");
   my $conf_dir      = ServerControl::FsLayout->get_directory("Configuration", "conf");
   my $cdcc          = ServerControl::FsLayout->get_file("Exec", "cdcc");
   my $user          = ServerControl::Args->get->{"user"};
   my $pid_file      = "$path/$pid_dir/$name.pid";
   my $exec_file     = ServerControl::FsLayout->get_file("Exec", "dccifd");

   my @options = (
      "-h " . ServerControl::Args->get->{"homedir"},
      "-R $path/$pid_dir",
      "-G off",
      "-Q",
      "-I " . ServerControl::Args->get->{"user"},
      ServerControl::Args->get->{"substitute"},
      "-l $path/" . ServerControl::FsLayout->get_directory("Runtime", "log"),
      "-T $path/" . ServerControl::FsLayout->get_directory("Runtime", "tmp"),
   );

   spawn("$path/$exec_file " . join(" ", @options));
}


1;
