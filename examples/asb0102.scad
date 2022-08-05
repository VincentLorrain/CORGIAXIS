include<CORGIAXIS/corgiAxis.scad>
use <parts01.scad>
use <parts02.scad>

r_main  = 10;
h_main  = 3;
r_stop  = 3;
h_stop  = 5;
r_in    = 3;
/**
* Define the axises use to assembled
**/
function axs_asb()=
[
[[0,0,0],[0,0,0]],
[[0,0,10],[0,90*$t+10,45*$t+20]],
];
/**
*get the axises for the assembled
**/
axs_abs0102 = axs_asb();
emptys(axs_abs0102);

/**
*PARTS01
**/
//get the parts axises
axs01 = axs_parts01(r_main,h_main,r_stop);
//module axis transform
ax_from_to(axs01[0],axs_abs0102[1])
color("blue",0.5)
parts01(
    r_main,
    h_main,
    r_stop,
    h_stop,
    r_in  
);
//same transform for axises so it can be used for the next parts
new_axs01 = axs_from_to(axs01[0],axs_abs0102[1],axs01);

/**
*PARTS02
**/
//get the parts axises
axs02 = axs_parts02(h_main);
//module axis transform on the new parts01 axises
ax_from_to(axs02[1],new_axs01[0])
color("red",0.5)
parts02(
    r_main,
    h_main,
    r_stop,
    h_stop
);
//same transform for axises so it can be used for the next parts
new_axs02 = axs_from_to(axs02[1],new_axs01[0],axs02);