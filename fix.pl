use strict;
use warnings;

use Font::TTF::Font;
use Encode;

my $songti = Font::TTF::Font->open("simsun.ttf") || die "Unable to read simsunb.ttf";
my $heiti = Font::TTF::Font->open("simhei.ttf") || die "Unable to read simhei.ttf";
my $kaiti = Font::TTF::Font->open("simkai.ttf") || die "Unable to read simkai.ttf";

my %fm;
$fm{6} = $heiti;
$fm{7} = $songti;
$fm{348} = $kaiti;

my %page_fonts;
my $cur_font_id = -1;
my $cur_font_obj = undef;
my $cur_obj_id = -1;
my $cur_content_id = -1;
while( my $line = <STDIN> )
{
    if( $line =~ /^(\d+) \d+ obj\s*$/ ) {
        $cur_obj_id = $1;
    }
    if( $line =~ /^\/Contents (\d+) 0 R$/ ) {
        $cur_content_id = $1;
    }
    if( $line =~ /\/TT(\d+) (\d+) 0 R$/ ) {
        my $pf = $page_fonts{$cur_content_id};
        $pf = $page_fonts{$cur_content_id} = {} unless defined $pf;
        $pf->{$1} = $2;
    }
    if( $line =~ /\/TT(\d+) .+? Tf$/ ) {
        $cur_font_id = $1;
        $cur_font_obj = $page_fonts{$cur_obj_id}->{$cur_font_id};
        #print STDERR join("\t",  "cur_font_obj", $cur_font_obj, $cur_obj_id, $cur_font_id), "\n"
    }
    if( $line =~ /^\(\\(\d{3})\\(\d{3}) \)Tj$/ ) {
        #print STDERR join("\t", $cur_font_id, $fonts{$cur_font_id}, $1, $2), "\n";
        my $gbk = pack('CC', oct($1), oct($2));

        #print encode('utf-8', decode('gbk', $gbk)), "\n";
        #print STDERR $gbk, "\n";
        if( defined $fm{$cur_font_obj} ) {
            my $utf16 = ord(decode('gbk', $gbk));
            #print $utf16, "\n";
            my $cid = $fm{$cur_font_obj}->{'cmap'}->ms_lookup($utf16);
            if( not defined $cid ) {
                print STDERR join("\t", "UNDEFINED", $utf16), "\n";
                $cid = 0xFFFD;
            } 
            my $cid_hex = sprintf('%04X', $cid);
            $line = "<$cid_hex>Tj     \n";
        }
    } elsif( $line =~ /Tj$/ ) {
        print STDERR "XXX ", $line;
    }
    print $line;
}


#my $snum = $f->{'cmap'}->ms_lookup(0x611f);
#print $snum, "\n";
#$f->{'hmtx'}->read;
#my $sadv = $f->{'hmtx'}{'advance'}[$snum];
#print $sadv, "\n";
