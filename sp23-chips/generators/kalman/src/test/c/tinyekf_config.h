/*
 * TinyEKF: Extended Kalman Filter for embedded processors.
 *
 * tinyekf_config.h: static configuration parameters
 *
 * Copyright (C) 2015 Simon D. Levy
 *
 * MIT License
 */

/* states */
#define Nsta 8

/* observables */
#define Mobs 4
#ifdef SOFTWARE
typedef struct {

    int n;           /* number of state values */
    int m;           /* number of observables */

    double x[Nsta];     /* state vector */

    double P[Nsta][Nsta];  /* prediction error covariance */
    double Q[Nsta][Nsta];  /* process noise covariance */
    double R[Mobs][Mobs];  /* measurement error covariance */

    double G[Nsta][Mobs];  /* Kalman gain; a.k.a. K */

    double F[Nsta][Nsta];  /* Jacobian of process model */
    double H[Mobs][Nsta];  /* Jacobian of measurement model */

    double Ht[Nsta][Mobs]; /* transpose of measurement Jacobian */
    double Ft[Nsta][Nsta]; /* transpose of process Jacobian */
    double Pp[Nsta][Nsta]; /* P, post-prediction, pre-update */

    double fx[Nsta];   /* output of user defined f() state-transition function */
    double hx[Mobs];   /* output of user defined h() measurement function */

    /* temporary storage */
    double tmp0[Nsta][Nsta];
    double tmp1[Nsta][Mobs];
    double tmp2[Mobs][Nsta];
    double tmp3[Mobs][Mobs];
    double tmp4[Mobs][Mobs];
    double tmp5[Mobs]; 

} ekf_t;
#else 
typedef struct {

    int n;           /* number of state values */
    int m;           /* number of observables */

    uint16_t x[Nsta];     /* state vector */

    uint16_t P[Nsta][Nsta];  /* prediction error covariance */
    uint16_t Q[Nsta][Nsta];  /* process noise covariance */
    uint16_t R[Mobs][Mobs];  /* measurement error covariance */

    uint16_t G[Nsta][Mobs];  /* Kalman gain; a.k.a. K */

    uint16_t F[Nsta][Nsta];  /* Jacobian of process model */
    uint16_t H[Mobs][Nsta];  /* Jacobian of measurement model */

    uint16_t Ht[Nsta][Mobs]; /* transpose of measurement Jacobian */
    uint16_t Ft[Nsta][Nsta]; /* transpose of process Jacobian */
    uint16_t Pp[Nsta][Nsta]; /* P, post-prediction, pre-update */

    uint16_t fx[Nsta];   /* output of user defined f() state-transition function */
    uint16_t hx[Mobs];   /* output of user defined h() measurement function */

    /* temporary storage */
    uint16_t tmp0[Nsta][Nsta];
    uint16_t tmp1[Nsta][Mobs];
    uint16_t tmp2[Mobs][Nsta];
    uint16_t tmp3[Mobs][Mobs];
    uint16_t tmp4[Mobs][Mobs];
    uint16_t tmp5[Mobs]; 

} ekf_t;
#endif