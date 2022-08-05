include<CORGIAXIS/corgiAxis.scad>


/**
* Define the parts axises 
**/
function axs_parts02(h_main=3)=
[
[[0,0,0],[0,0,0]],
[[0,0,h_main],[0,0,0]],
];
/**
* the module of this parts
**/
module parts02(
    r_main = 5,
    h_main = 10,
    r_stop = 3,
    h_stop = 5
){
    //generate the axises 
    axs = axs_parts02(h_main);
    
    emptys(axs);

    ax_from_to(AX_NULL,axs[0])
    cylinder(h = h_main,r=r_main);
    ax_from_to(AX_NULL,axs[1])
    cylinder(h = h_stop,r=r_stop);

}

 parts02();