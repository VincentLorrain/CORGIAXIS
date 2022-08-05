
////////////////////////
// Quaternion AND EURLER
////////////////////////
/**
* [W,X,Y,Z]
**/

/**
* CONST
**/
QuaI = [1,0,0,0];
QR_W = 0;
QR_X = 1;
QR_Y = 2;
QR_Z = 3;

/**
* QUATERNION AND EULER TOOL
**/

//https://stackoverflow.com/questions/56207448/efficient-quaternions-to-euler-transformation
//http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToEuler/

/**
 * @brief get the euler from quaternion
 * @param eul euler rotation
 * @return the euler of the quaterion rotation
 */
function quaternion_to_euler(qr,deltaSingu = 1) = 
let(
    n = norm(qr),
    w = qr[QR_W]/n,
    x = qr[QR_X]/n,
    y = qr[QR_Y]/n,
    z = qr[QR_Z]/n,
    
    test = +2.0 * (w * y - z * x),
    singuNorth = (test >= deltaSingu),
    singuSouth = (test <= -deltaSingu),

    t0 = +2.0 * (w * x + y * z),
    t1 = +1.0 - 2.0 * (x*x + y*y),
    
    rx = singuNorth ?  2 * atan2(x,w):
        singuSouth ? -2 * atan2(x,w)://-PI/2:
        atan2(t0, t1),
    //rx = -atan2(t0, t1),

    t2 = singuNorth ? 1.0:
        singuSouth ? -1.0://-PI/2:
        test,
    ry = asin(t2),

    t3 = +2.0 * (w * z + x * y),
    t4 = +1.0 - 2.0 * (y*y + z * z),
    
    rz = singuNorth ? 0:
        singuSouth ?  0://-PI/2:
        atan2(t3, t4)
        
    //rz = atan2(t3, t4)
    
 ) [rx,ry,rz];
 
//https://automaticaddison.com/how-to-convert-euler-angles-to-quaternions-using-python/
/**
 * @brief get the quaternion for euler 
 * @param eul euler rotation
 * @return the quaterion of the euler rotation
 */
function euler_to_quaternion(eul) = 
assert(len(eul) == 3)
let(
    cx = cos(eul[0]/2),
    cy = cos(eul[1]/2),
    cz = cos(eul[2]/2),
    
    sx = sin(eul[0]/2),
    sy = sin(eul[1]/2),
    sz = sin(eul[2]/2),
    
    qw = cx * cy * cz + sx * sy * sz,
    qx = sx * cy * cz - cx * sy * sz,
    qy = cx * sy * cz + sx * cy * sz,
    qz = cx * cy * sz - sx * sy * cz 
    
)[qw,qx,qy,qz];


/**
* QUATERNION OPERATOR
**/

/**
 * @brief conjugate quaternion
 * @param qr quaterion
 * @return conjugate quaternion
 */
function conjugate_quaternion(qr) = 
[qr[QR_W],-qr[QR_X],-qr[QR_Y],-qr[QR_Z]];

/**
 * @brief magnitude quaternion
 * @param qr quaterion
 * @return magnitude quaternion
 */
function magnitude_quaternion(qr)= 
sqrt(qr[QR_W]^2 + qr[QR_X]^2 + qr[QR_Y]^2 + qr[QR_Z]^2);

/**
 * @brief inverse quaternion
 * @param qr quaterion
 * @return inverse quaternion
 */
function inverse_quaternion(qr)= 
let(
    qr_c = conjugate_quaternion(qr),
    qr_m = magnitude_quaternion(qr)^2
) 
[qr_c[QR_W]/qr_m,qr_c[QR_X]/qr_m,qr_c[QR_Y]/qr_m,qr_c[QR_Z]/qr_m] ;

/**
 * @brief product quaternion is add quaternion rotation
 * @param qr_a quaterion
 * @param qr_b quaterion
 * @return product quaternion
 */
function quaternion_product(qr_a,qr_b)= 
let(
qw = qr_a[QR_W]*qr_b[QR_W] - qr_a[QR_X]*qr_b[QR_X] - qr_a[QR_Y]*qr_b[QR_Y] - qr_a[QR_Z]*qr_b[QR_Z],
qx = qr_a[QR_W]*qr_b[QR_X] + qr_a[QR_X]*qr_b[QR_W] + qr_a[QR_Y]*qr_b[QR_Z] - qr_a[QR_Z]*qr_b[QR_Y],
qy = qr_a[QR_W]*qr_b[QR_Y] - qr_a[QR_X]*qr_b[QR_Z] + qr_a[QR_Y]*qr_b[QR_W] + qr_a[QR_Z]*qr_b[QR_X],
qz = qr_a[QR_W]*qr_b[QR_Z] + qr_a[QR_X]*qr_b[QR_Y] - qr_a[QR_Y]*qr_b[QR_X] + qr_a[QR_Z]*qr_b[QR_W]

) [qw,qx,qy,qz];

/**
 * @brief div quaternion is sub quaternion rotation
 * @param qr_a quaterion
 * @param qr_b quaterion
 * @return div quaternion
 */
function quaternion_div(qr_a,qr_b)= 
quaternion_product(qr_a,inverse_quaternion(qr_b));

/**
 * @brief add eurler rot to quaternion
 * @param qr quaternion rotation 
 * @param r quaternion rotation 
 * @return the point position after rotation
**/
function add_rot_eul_qua(r,qr) = 
let(
    qr_in = euler_to_quaternion(r),
    qr_p  = quaternion_product(qr,qr_in),
    r_new = quaternion_to_euler(qr_p)
)r_new; 
/**
 * @brief rotatate point pivot center
 * @param p a point [x,y,z] 
 * @param r euler rotation 
 * @return the point position after rotation
**/
function rot_point_eul(p,r) = 
let(
    p_ext = [0,p[0],p[1],p[2]],
    qr    = euler_to_quaternion(r),
    qr_c  = conjugate_quaternion(qr),
    p_new = quaternion_product(quaternion_product(qr,p_ext), qr_c) 
)[p_new[1],p_new[2],p_new[3]];
/**
 * @brief rotatate point pivot center
 * @param p a point [x,y,z] 
 * @param qr quaternion rotation 
 * @return the point position after rotation
**/
function rot_point_qua(p,qr) = 
let(
    p_ext  = [0,p[0],p[1],p[2]],
    qr_c   = conjugate_quaternion(qr),
    p_new  = quaternion_product(quaternion_product(qr,p_ext), qr_c) 
)[p_new[1],p_new[2],p_new[3]]; 
