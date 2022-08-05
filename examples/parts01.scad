include<CORGIAXIS/corgiAxis.scad>

/**
* Define the parts axises 
**/
function axs_parts01(r_main = 10,h_main=3,r_stop=3)=
[
[[0,0,0],[0,0,0]],
[[0,r_main-r_stop,h_main],[0,0,0]],
];

/**
* the module of this parts
**/
module parts01(
    r_main = 10,
    h_main = 3,
    r_stop = 3,
    h_stop = 5,
    r_in = 3
){
    //plots the axises 
    axs = axs_parts01(r_main,h_main,r_stop);
    
    emptys(axs);
    difference(){
        ax_from_to(AX_NULL,axs[0])
        cylinder(h = h_main,r=r_main);
        ax_from_to(AX_NULL,axs[0])
        cylinder(h = h_main+1,r=r_in);
    }
    ax_from_to(AX_NULL,axs[1])
    cylinder(h = h_stop,r=r_stop);

}

parts01();