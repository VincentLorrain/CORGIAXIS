include<quaternionR.scad>

///////////////////
//AXIS
///////////////////
/**
* the axis model is base on point and a euler rotation
* [[x,y,z],[rx,ry,rz]]
* the axises are list of axis
**/

//TODO
//function is_axis(ax) = 

module axis_asserts (ax){
    error_message  = "axis format must be [[x,y,z],[rx,ry,rz]]";
    assert(is_list(ax) == true ,error_message);
    assert(len(ax) == 2 , error_message);
    assert(is_list(ax[AX_P]) && is_list(ax[AX_R]) , error_message);
    assert(len (ax[AX_P]) ==3 && len (ax[AX_R]) ==3 , error_message); 
}



/**
* CONST
**/
AX_NULL = [[0,0,0],[0,0,0]];
AX_P = 0;
AX_R = 1;

/**
* AXIS TRANSFORM MODULE
**/

/**
 * @brief module copy the position of axis
 * @param ax_from how is the reference 
 * @param ax_to how is targer
 */
module ax_copy_pos(ax_from,ax_to){
    translate(ax_to[AX_P])
    translate(-ax_from[AX_P])
    children();
}

/**
 * @brief module copy the rotation of axis
 * @param ax_from how is the reference 
 * @param ax_to how is targer
 */
module ax_copy_rot(ax_from,ax_to){
    qr_to   = euler_to_quaternion(ax_to[AX_R]);
    qr_from = euler_to_quaternion(ax_from[AX_R]);
    qr_diff = quaternion_div(qr_to,qr_from);
    r_new   = quaternion_to_euler(qr_diff);
    
    translate(ax_from[AX_P])
    rotate(r_new)
    translate(-ax_from[AX_P])
    children(); 
}
/**
 * @brief module copy the position of axis
 * @param ax_from how is the reference 
 * @param ax_to how is targer
 */
module ax_from_to(ax_from,ax_to){

    qr_to   = euler_to_quaternion(ax_to[AX_R]);
    qr_from = euler_to_quaternion(ax_from[AX_R]);
    qr_diff = quaternion_div(qr_to,qr_from); 
    r_new   = quaternion_to_euler(qr_diff);
    
    translate(ax_to[AX_P])
    rotate(r_new)
    translate(-ax_from[AX_P])
    children();
}
/**
 * @brief rotation of axis
 * @param ax_from how is the reference 
 * @param ax_to how is targer
 */
module ax_rot(ax,r){
    ax_copy_rot(AX_NULL,ax)
    translate(ax[0])
    rotate(r)
    translate(-ax[0])
    children();
}

/**
* AXIS TRANSFORM FOR AXISES
**/

/**
 * @brief fuction copy the position and rotation of axis
 * @param ax_from how is the reference 
 * @param ax_to how is targer
 * @param axs the input list of axis
 * @return the new axs transforme
 */
function axs_from_to(ax_from,ax_to,axs) = let(
    //get the rotation to applie
    qr_to   = euler_to_quaternion(ax_to[AX_R]),
    qr_from = euler_to_quaternion(ax_from[AX_R]),
    qr_diff = quaternion_div(qr_to,qr_from),

    //translate to from
    axs_new_t = [for(i = [0 : len(axs) - 1]) 
    [axs[i][AX_P]-ax_from[AX_P], axs[i][AX_R]]],
    //applie point rotate
    axs_new_r = [for(i = [0 : len(axs) - 1]) 
    [rot_point_qua(axs_new_t[i][AX_P],qr_diff), add_rot_eul_qua(axs_new_t[i][AX_R],qr_diff)]],
    //translate to to
    axs_new = [for(i = [0 : len(axs) - 1])
    [axs_new_r[i][AX_P] +ax_to[AX_P], axs_new_r[i][AX_R]]]

)axs_new;
    
/**
 * @brief fuction copy the rotation of axis
 * @param ax_from how is the reference 
 * @param ax_to how is targer
 * @param axs the input list of axis
 * @return the new axs transforme
 */
    
function axs_copy_rot(ax_from,ax_to,axs)=let(
    qr_to   = euler_to_quaternion(ax_to[AX_R]),
    qr_from = euler_to_quaternion(ax_from[AX_R]),
    qr_diff = quaternion_div(qr_to,qr_from),
    
    axs_new_r = [for(i = [0 : len(axs) - 1]) 
    [rot_point_qua(axs[i][AX_P],qr_diff), add_rot_eul_qua(axs[i][AX_R],qr_diff)]]
)axs_new_r;

/**
 * @brief fuction copy the position axis
 * @param ax_from how is the reference 
 * @param ax_to how is targer
 * @param axs the input list of axis
 * @return the new axs transforme
 */
    
function axs_copy_pos(ax_from,ax_to,axs)=let(
    axs_new_t = [for(i = [0 : len(axs) - 1]) 
    [axs[i][AX_P]+ax_to[AX_P]-ax_from[AX_P], axs[i][AX_R]]]
)axs_new_t;
   

/**
* METRIC TOOL
**/

function ax_dist(ax_from,ax_to,axs) = norm(ax_to[AX_P] - ax_from[AX_P]);

/**
*VISUALISATION TOOL
**/

/**
 * @brief module for plot one axis
 * @param ax one axis values
 * @param name str plot in center of axis
 */
module empty(ax , name = " "){
    
    //echo(ax[AX_P],ax);
    translate(ax[AX_P])
    rotate(ax[AX_R]){
        %union(){
        
            sphere(r=1.5);
            color("blue",0.25)
            translate([0,0,5])
            cylinder(h=10,r1=1,r2=0,center=true);
            
            color("green",0.25)
            rotate([-90,0,0])
            translate([0,0,5])
            cylinder(h=10,r1=1,r2=0,center=true);
            
            color("red",0.25)
            rotate([0,90,0])
            translate([0,0,5])
            cylinder(h=10,r1=1,r2=0,center=true);
            
            //translate([-3.5,-3,-0])
            //text(name,size = 3);
            
        }
        children();
    }
}
/**
 * @brief module for plot one axises
 * @param axs  axises
 */
module emptys(axs){
    for (ax = [ 0 : len(axs) - 1 ]) {
        empty(axs[ax],str(ax));
    }
}
//////////////
//
//////////////

module ax_target(ax_from,ax_to){
    
    vec = ax_to[AX_P] - ax_from[AX_P];
    nVec = norm(vec);
    ot   = acos(vec.z/nVec);
    ph   = atan2(vec.y/nVec,vec.x/nVec);
    
    rx = -ot;
    ry = 0;
    rz = ph-90;

    r_new = [rx,ry,rz];
    
    translate(ax_from[AX_P])
    rotate(r_new)
    translate(-ax_from[AX_P])
    children(); 
}

function axs_target(ax_from,ax_to,axs)=
let(
    vec = ax_to[AX_P] - ax_from[AX_P],
    nVec = norm(vec),
    ot   = acos(vec.z/nVec),
    ph   = atan2(vec.y/nVec,vec.x/nVec),
    
    rx = -ot,
    ry = 0,
    rz = ph-90,

    ax_new = [[0,0,0],[rx,ry,rz]]
    
    
    
)axs_copy_rot(ax_from,ax_new,axs);


