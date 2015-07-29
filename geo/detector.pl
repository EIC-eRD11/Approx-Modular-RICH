#############################################################
#############################################################
#  All dimensions are in mm
#  Use the hit type eic_rich 
#  
#  The geometry are divided in 5 parts: 
#  Aerogel, Fresnel lens, Mirrors, Photonsensor, and Readout
#
#############################################################
#############################################################

use strict;
use warnings;
use Getopt::Long;
use Math::Trig;

our %configuration;


my $DetectorMother="root";
my $DetectorName = 'meic_det1_rich';
my $hittype="eic_rich";

#######------ Define detector size and location ------####### 
my $box_halfx = 101;
my $box_halfy = 101;
my $box_halfz = 101;

my $agel_halfx = 100;
my $agel_halfy = 100;

my $agel1_halfx = 100;
my $agel1_halfy = 100;
my $agel1_halfz = 10.0;

my $agel2_halfx = 100;
my $agel2_halfy = 100;
my $agel2_halfz = 10.0;

my $phodet_halfx = $agel_halfx*0.8;
my $phodet_halfy = $agel_halfy*0.8;
my $phodet_halfz = 1.0;

my $readout_halfz = 4.0;

my $offset = $box_halfz+50;


my $no_overlap;
my $agel1_z = -90;
my $agel2_z = $agel1_z + 20 + $no_overlap;
my $phodet_z = 90.0;
my @readout_z = ($phodet_z-$phodet_halfz+3.0, $phodet_z-$phodet_halfz+2.0*$readout_halfz);

my @Z = ($offset, $agel1_z, $agel2_z, $phodet_z);
sub print_detector()
{
	print "Printing detector positions and sizes ...\n\n";

	print "hold box position: ( 0.0, 0.0, $Z[0] mm),  half size in XYZ: ( $box_halfx mm, $box_halfy mm, $box_halfz mm )\n";
	print "first aerogel position: ( 0.0, 0.0, $Z[1] mm),  half size in XYZ: ( $agel1_halfx mm, $agel1_halfy mm, $agel1_halfz mm )\n";
	print "second aerogel position: ( 0.0, 0.0, $Z[2] mm),  half size in XYZ: ( $agel2_halfx mm, $agel2_halfy mm, $agel2_halfz mm )\n";
	print "photon detector position: ( 0.0, 0.0, $Z[3] mm),  half size in XYZ: ( $phodet_halfx mm, $phodet_halfy mm, $phodet_halfz mm )\n";

}

#######------ Define the holder Box for Detectors ------#######
my $box_name = "detector_holder";
my $box_mat = "Air_Opt";
sub build_box()
{
	my @box_pos  = ( 0.0, 0.0, $offset );
	my @box_size = ( $box_halfx, $box_halfy, $box_halfz );
        my %detector=init_det();
        $detector{"name"} = "$DetectorName\_$box_name";
        $detector{"mother"} = "$DetectorMother";
        $detector{"description"} = "$DetectorName\_$box_name";
        $detector{"pos"} = "$box_pos[0]*mm $box_pos[1]*mm $box_pos[2]*mm";
        $detector{"color"} = "ffffff";
        $detector{"type"} = "Box";
        $detector{"visible"} = "1";
        $detector{"dimensions"} = "$box_size[0]*mm $box_size[1]*mm $box_size[2]*mm";
        $detector{"material"} = "$box_mat";
        $detector{"sensitivity"} = "no";
        $detector{"hit_type"}    = "no";
        $detector{"identifiers"} = "no";
        print_det(\%configuration, \%detector);
}

#######------ Aerogel ------#######
sub build_aerogel()
{
	my $agel1_name = "Aerogel1";
	my $agel1_mat  = "aerogel1";
	my @agel1_pos  = ( 0.0, 0.0, $agel1_z);
	my @agel1_size = ( $agel1_halfx, $agel1_halfy, $agel1_halfz );
        my %detector=init_det();
        $detector{"name"} = "$DetectorName\_$agel1_name";
        $detector{"mother"} = "$DetectorName\_$box_name";
        $detector{"description"} = "$DetectorName\_$agel1_name";
        $detector{"pos"} = "$agel1_pos[0]*mm $agel1_pos[1]*mm $agel1_pos[2]*mm";
        $detector{"color"} = "ffa500";
        $detector{"type"} = "Box";
        $detector{"dimensions"} = "$agel1_size[0]*mm $agel1_size[1]*mm $agel1_size[2]*mm";
        $detector{"material"} = "$agel1_mat";
        $detector{"sensitivity"} = "$hittype";
        $detector{"hit_type"}    = "$hittype";
        $detector{"identifiers"} = "id manual 1";
        print_det(\%configuration, \%detector);

	my $agel2_name = "Aerogel2";
        my $agel2_mat  = "aerogel2";
        my @agel2_pos  = ( 0.0, 0.0, $agel2_z);
        my @agel2_size = ( $agel2_halfx, $agel2_halfy, $agel2_halfz );
        %detector=init_det();
        $detector{"name"} = "$DetectorName\_$agel2_name";
        $detector{"mother"} = "$DetectorName\_$box_name";
        $detector{"description"} = "$DetectorName\_$agel2_name";
        $detector{"pos"} = "$agel2_pos[0]*mm $agel2_pos[1]*mm $agel2_pos[2]*mm";
        $detector{"color"} = "00FF00";
        $detector{"type"} = "Box";
        $detector{"dimensions"} = "$agel2_size[0]*mm $agel2_size[1]*mm $agel2_size[2]*mm";
        $detector{"material"} = "$agel2_mat";
        $detector{"sensitivity"} = "$hittype";
        $detector{"hit_type"}    = "$hittype";
        $detector{"identifiers"} = "id manual 2";
        print_det(\%configuration, \%detector);

}

######------ Fresnel lens ------######
#### later  

######------ photon detector ------######
my $photondet_name = "Photondet";
#my $photondet_mat  = "Aluminum";
my $photondet_mat  = "Air_Opt";
sub build_photondet()
{
	my @photondet_pos  = ( 0.0, 0.0, $phodet_z );
	my @photondet_size = ( $phodet_halfx, $phodet_halfy, $phodet_halfz );
	my %detector=init_det();
	$detector{"name"} = "$DetectorName\_$photondet_name";
	$detector{"mother"} = "$DetectorName\_$box_name";
	$detector{"description"} = "$DetectorName\_$photondet_name";
	$detector{"pos"} = "$photondet_pos[0]*mm $photondet_pos[1]*mm $photondet_pos[2]*mm";
	$detector{"rotation"} = "0*deg 0*deg 0*deg";
	$detector{"color"} = "0000A0";
	$detector{"type"} = "Box";
	$detector{"dimensions"} = "$photondet_size[0]*mm $photondet_size[1]*mm $photondet_size[2]*mm";
	$detector{"material"} = "$photondet_mat";
	$detector{"mfield"} = "no";
	$detector{"sensitivity"} = "$hittype";
	$detector{"hit_type"}    = "$hittype";
	$detector{"identifiers"} = "id manual 3";
	print_det(\%configuration, \%detector);
}


######------ reflection mirrors ------######
my $mirror_mat  = "Aluminum";
sub build_mirrors()
{
	my $dx1 = $agel_halfx-0.3;            ## 0.3 mm less avoiding overlap
	my $dx2 = ($agel_halfx)*0.8-0.3;      ## 0.3 mm less avoiding overlap
	my $dy1 = 0.1;
	my $dy2 = 0.1;
	my $dz = ($phodet_z - $phodet_halfz + 60.)/2.0;
	my $phi = atan2($agel_halfx-$phodet_halfx, 2.0*$dz);
	my $delxy = $dz*sin($phi) + 1.0;

	my $mirror_halfx = $agel_halfx;
	my $mirror_halfy = 1.0;
	my $mirror_halfz = ($phodet_z-$phodet_halfz-60.)/2.0;

	####### back mirror
	my $phi_back = $phi*180.0/pi;
	my @mirror_back_pos  = ( $agel_halfy+$mirror_halfy-$delxy, 0.0, ($phodet_z-$phodet_halfz-60.)/2.0 );
	my $mirror_back_name = "mirror_back";
        my %detector=init_det();
        $detector{"name"} = "$DetectorName\_$mirror_back_name";
        $detector{"mother"} = "$DetectorName\_$box_name";
        $detector{"description"} = "$DetectorName\_$mirror_back_name";
        $detector{"pos"} = "$mirror_back_pos[0]*mm $mirror_back_pos[1]*mm $mirror_back_pos[2]*mm";
        $detector{"rotation"} = "0.0*deg $phi_back*deg 90*deg";
        $detector{"color"} = "ffff00";
        $detector{"type"} = "Trd";
        $detector{"dimensions"} = "$dx1*mm $dx2*mm $dy1*mm $dy2*mm $dz*mm";
        $detector{"material"} = "$mirror_mat";
	$detector{"sensitivity"} = "mirror: rich_mirrors";
	$detector{"hit_type"} = "no";
        $detector{"identifiers"} = "id manual 4";
        print_det(\%configuration, \%detector);

	
	####### front mirror
	my $phi_front = -1.0*$phi*180.0/pi;
	my @mirror_front_pos  = ( -1.*($agel_halfy+$mirror_halfy-$delxy), 0.0, ($phodet_z-$phodet_halfz-60.)/2.0);
	my $mirror_front_name = "mirror_front";
        %detector=init_det();
        $detector{"name"} = "$DetectorName\_$mirror_front_name";
        $detector{"mother"} = "$DetectorName\_$box_name";
        $detector{"description"} = "$DetectorName\_$mirror_front_name";
        $detector{"pos"} = "$mirror_front_pos[0]*mm $mirror_front_pos[1]*mm $mirror_front_pos[2]*mm";
        $detector{"rotation"} = "0*deg $phi_front*deg 90*deg";
        $detector{"color"} = "ffff00";
        $detector{"type"} = "Trd";
        $detector{"dimensions"} = "$dx1*mm $dx2*mm $dy1*mm $dy2*mm $dz*mm";
        $detector{"material"} = "$mirror_mat";
	$detector{"sensitivity"} = "mirror: rich_mirrors";
	$detector{"hit_type"} = "no";
        $detector{"identifiers"} = "id manual 5";
        print_det(\%configuration, \%detector);
	
	####### top mirror
	my $phi_top = -1.0*$phi*180.0/pi;
	my @mirror_top_pos  = ( 0.0, $agel_halfy+$mirror_halfy-$delxy, ($phodet_z-$phodet_halfz-60.)/2.0);
	my $mirror_top_name = "mirror_top";
        %detector=init_det();
        $detector{"name"} = "$DetectorName\_$mirror_top_name";
        $detector{"mother"} = "$DetectorName\_$box_name";
        $detector{"description"} = "$DetectorName\_$mirror_top_name";
        $detector{"pos"} = "$mirror_top_pos[0]*mm $mirror_top_pos[1]*mm $mirror_top_pos[2]*mm";
        $detector{"rotation"} = "$phi_top*deg 0*deg 0*deg";
        $detector{"color"} = "ffff00";
        $detector{"type"} = "Trd";
        $detector{"dimensions"} = "$dx1*mm $dx2*mm $dy1*mm $dy2*mm $dz*mm";
        $detector{"material"} = "$mirror_mat";
	$detector{"sensitivity"} = "mirror: rich_mirrors";
	$detector{"hit_type"} = "no";
        $detector{"identifiers"} = "id manual 6";
        print_det(\%configuration, \%detector);

	####### bottom mirror
	my $phi_bottom = $phi*180.0/pi;
	my @mirror_bottom_pos  = ( 0.0, -1.0*($agel_halfy+$mirror_halfy-$delxy), ($phodet_z-$phodet_halfz-60.)/2.0);
	my $mirror_bottom_name = "mirror_bottom";
        %detector=init_det();
        $detector{"name"} = "$DetectorName\_$mirror_bottom_name";
        $detector{"mother"} = "$DetectorName\_$box_name";
        $detector{"description"} = "$DetectorName\_$mirror_bottom_name";
        $detector{"pos"} = "$mirror_bottom_pos[0]*mm $mirror_bottom_pos[1]*mm $mirror_bottom_pos[2]*mm";
        $detector{"rotation"} = "$phi_bottom*deg 0*deg 0*deg";
        $detector{"color"} = "ffff00";
        $detector{"type"} = "Trd";
        $detector{"dimensions"} = "$dx1*mm $dx2*mm $dy1*mm $dy2*mm $dz*mm";
        $detector{"material"} = "$mirror_mat";
	$detector{"sensitivity"} = "mirror: rich_mirrors";
	$detector{"hit_type"} = "no";
        $detector{"identifiers"} = "id manual 7";
        print_det(\%configuration, \%detector);
}


######------ readout hardware ------######
my $readoutdet_name = "readout";
my $readout_mat  = "Aluminum";
my @readoutdet_pos  = ( 0.0, 0.0, 0.0 );
my @readout_rinner = ( $phodet_halfx+1, $phodet_halfx+1 );
my @readout_router = ( $agel_halfx, $agel_halfy );

sub build_readout()
{
        my %detector=init_det();
        $detector{"name"} = "$DetectorName\_$readoutdet_name";
        $detector{"mother"} = "$DetectorName\_$box_name";
        $detector{"description"} = "$DetectorName\_$readoutdet_name";
        $detector{"pos"} = "$readoutdet_pos[0]*mm $readoutdet_pos[1]*mm $readoutdet_pos[2]*mm";
        $detector{"rotation"} = "0*deg 0*deg 0*deg";
        $detector{"color"} = "ff0000";
	$detector{"type"} = "Pgon";    ### Polyhedra
	my $dimen = "45*deg 360*deg 4*counts 2*counts";
	for(my $i=0; $i<2; $i++) {$dimen = $dimen ." $readout_rinner[$i]*mm";}
	for(my $i=0; $i<2; $i++) {$dimen = $dimen ." $readout_router[$i]*mm";}
	for(my $i=0; $i<2; $i++) {$dimen = $dimen ." $readout_z[$i]*mm";}
	$detector{"dimensions"} = "$dimen";
        $detector{"material"} = "$readout_mat";
        $detector{"sensitivity"} = "no";
        $detector{"hit_type"}    = "no";
        $detector{"identifiers"} = "no";
        print_det(\%configuration, \%detector);

}


sub build_detector()
{
	print_detector();
	build_box();
	build_aerogel();
	build_photondet();
	build_mirrors();
	build_readout();
}
