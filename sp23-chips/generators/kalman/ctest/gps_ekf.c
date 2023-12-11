/* gps_ekf: TinyEKF test case using You Chong's GPS example:
 * 
 *   http://www.mathworks.com/matlabcentral/fileexchange/31487-extended-kalman-filter-ekf--for-gps
 * 
 * Reads file gps.csv of satellite data and writes file ekf.csv of mean-subtracted estimated positions.
 *
 *
 * References:
 *
 * 1. R G Brown, P Y C Hwang, "Introduction to random signals and applied 
 * Kalman filtering : with MATLAB exercises and solutions",1996
 *
 * 2. Pratap Misra, Per Enge, "Global Positioning System Signals, 
 * Measurements, and Performance(Second Edition)",2006
 * 
 * Copyright (C) 2015 Simon D. Levy
 *
 * MIT License
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <strings.h>
#include <math.h>
#include "fp16.h"
#include "tinyekf_config.h"
#include "tiny_ekf.h"
#include "accelerator_funcs.h"


#ifdef SOFTWARE

// positioning interval
static const float T = 1;
static const float gps_data[5][16]= {
        {-11602023.9489137008786201,14063117.4931115992367268,18811434.3112745992839336,-20853271.5736341997981071,1806977.2118581600952893,16542682.1237923000007868,-14355926.0172339994460344,8650961.8841098193079233,20736354.9805863983929157,7475239.6753052901476622,12966181.2771377004683018,21931576.7921750992536545,23568206.4173782989382744,26183921.4577450007200241,24652215.2627705000340939,25606982.9330466017127037},
        {-11602700.4096150007098913,14060708.1637619994580746,18812823.4023028016090393,-20855049.9291185997426510,1805887.1306580700911582,16540582.4659656994044781,-14356344.1729805991053581,8648384.4768619798123837,20737164.3397033996880054,7472917.3215693095698953,12967714.4596338998526335,21931442.6029887981712818,23568427.7909861989319324,26184404.1127416007220745,24652621.9011856988072395,25606499.4748000986874104},
        {-11603377.0261803008615971,14058298.6961425002664328,18814212.0761809013783932,-20856828.1167653985321522,1804797.2804981300141662,16538482.4609003998339176,-14356762.4791433997452259,8645806.9947465099394321,20737973.2627678997814655,7470595.0720982002094388,12969247.7736987993121147,21931307.9468086995184422,23568650.0894557014107704,26184884.7086125016212463,24653025.2764103002846241,25606016.6971120014786720},
        {-11604053.7986267991364002,14055889.0902858991175890,18815600.3328956998884678,-20858606.1364935003221035,1803707.6613832199946046,16536382.1086646001785994,-14357180.9357223007827997,8643229.4378561992198229,20738781.7497542984783649,7468272.9269468197599053,12970781.2192928008735180,21931172.8236371017992496,23568869.5260895006358624,26185366.6481501981616020,24653428.8435873985290527,25605534.4603805989027023},
        {-11604730.7269448004662991,14053479.3463228996843100,18816988.1723781004548073,-20860383.9882667995989323,1802618.2732910700142384,16534281.4092740993946791,-14357599.5427193008363247,8640651.8062730506062508,20739589.8006406985223293,7465950.8861416298896074,12972314.7963951993733644,21931037.2334740012884140,23569094.4420915991067886,26185845.7782028988003731,24653834.8537949994206429,25605048.9604584984481335}
    };

static void blkfill(ekf_t * ekf, const float * a, int off)
{
    off *= 2;

    ekf->Q[off]   [off]   = a[0]; 
    ekf->Q[off]   [off+1] = a[1];
    ekf->Q[off+1] [off]   = a[2];
    ekf->Q[off+1] [off+1] = a[3];
}


static void init(ekf_t * ekf)
{
    // Set Q, see [1]
    const float Sf    = 36;
    const float Sg    = 0.01;
    const float sigma = 5;         // state transition variance
    const float Qb[4] = {Sf*T+Sg*T*T*T/3, Sg*T*T/2, Sg*T*T/2, Sg*T};
    const float Qxyz[4] = {sigma*sigma*T*T*T/3, sigma*sigma*T*T/2, sigma*sigma*T*T/2, sigma*sigma*T};

    blkfill(ekf, Qxyz, 0);
    blkfill(ekf, Qxyz, 1);
    blkfill(ekf, Qxyz, 2);
    blkfill(ekf, Qb,   3);

    // initial covariances of state noise, measurement noise
    float P0 = 10;
    float R0 = 36;

    int i;

    for (i=0; i<8; ++i)
        ekf->P[i][i] = P0;

    for (i=0; i<4; ++i)
        ekf->R[i][i] = R0;

    // position
    ekf->x[0] = -2.168816181271560e+006;
    ekf->x[2] =  4.386648549091666e+006;
    ekf->x[4] =  4.077161596428751e+006;

    // velocity
    ekf->x[1] = 0;
    ekf->x[3] = 0;
    ekf->x[5] = 0;

    // clock bias
    ekf->x[6] = 3.575261153706439e+006;

    // clock drift
    ekf->x[7] = 4.549246345845814e+001;
    int j;
    for (j=0; j<8; ++j)
        ekf->F[j][j] = 1;

    for (j=0; j<4; ++j)
        ekf->F[2*j][2*j+1] = T;
}

static void model(ekf_t * ekf, float SV[4][3])
{ 

    int i, j;

    for (j=0; j<8; j+=2) {
        ekf->fx[j] = ekf->x[j] + T * ekf->x[j+1];
        ekf->fx[j+1] = ekf->x[j+1];
    }

    

    float dx[4][3];

    for (i=0; i<4; ++i) {
        ekf->hx[i] = 0;
        for (j=0; j<3; ++j) {
            float d = ekf->fx[j*2] - SV[i][j];
            dx[i][j] = d;
            ekf->hx[i] += d*d;
        }
        ekf->hx[i] = powf(ekf->hx[i], 0.5) + ekf->fx[6];
    }

    for (i=0; i<4; ++i) {
        for (j=0; j<3; ++j) 
            ekf->H[i][j*2]  = dx[i][j] / ekf->hx[i];
        ekf->H[i][6] = 1;
    }   
}

static void readline(char * line, FILE * fp)
{
    fgets(line, 1000, fp);
}

static void readdata(float SV_Pos[4][3], float SV_Rho[4], int n)
{
    //char line[1000];

    //readline(line, fp);

    //char * p = strtok(line, ",");

    int i, j;

    for (i=0; i<4; ++i)
        for (j=0; j<3; ++j) {
            SV_Pos[i][j] = gps_data[n][(4 * i) + j];
            //p = strtok(NULL, ",");
        }

    for (j=0; j<4; ++j) {
        SV_Rho[j] = gps_data[n][12 + j];
        //p = strtok(NULL, ",");
    }
}


/*static void skipline(FILE * fp)
{
    char line[1000];
    readline(line, fp);
}*/

void error(const char * msg)
{
    fprintf(stderr, "%s\n", msg);
}

int main(int argc, char ** argv)
{    
    
    // Do generic EKF initialization
    ekf_t ekf;
    ekf_init(&ekf, Nsta, Mobs);

    // Do local initialization
    init(&ekf);

    // Open input data file
    //FILE * ifp = fopen("gps.csv", "r");

    // Skip CSV header
    //skipline(ifp);
    
    // Make a place to store the data from the file and the output of the EKF
    float SV_Pos[4][3];
    float SV_Rho[4];
    float Pos_KF[25][3];

    // Open output CSV file and write header
    const char * OUTFILE = "ekf.csv";
    //FILE * ofp = fopen(OUTFILE, "w");
    //fprintf(ofp, "X,Y,Z\n");
    printf("begin software: \n");
    int j, k;

    // Loop till no more data
    for (j=0; j<5; ++j) {
        printf("Doing Step: %d\n", j);

        readdata(SV_Pos, SV_Rho, j);

        model(&ekf, SV_Pos);

        ekf_step(&ekf, SV_Rho);

        // grab positions, ignoring velocities
        for (k=0; k<3; ++k)
            Pos_KF[j][k] = ekf.x[2*k];
    }

    // Compute means of filtered positions
    float mean_Pos_KF[3] = {0, 0, 0};
    for (j=0; j<5; ++j) 
        for (k=0; k<3; ++k)
            mean_Pos_KF[k] += Pos_KF[j][k];
    for (k=0; k<3; ++k)
        mean_Pos_KF[k] /= 5;


    // Dump filtered positions minus their means
    for (j=0; j<5; ++j) {
        float a = (Pos_KF[j][0] - mean_Pos_KF[0]);
        float b = (Pos_KF[j][1] - mean_Pos_KF[1]);
        float c = (Pos_KF[j][2] - mean_Pos_KF[2]);
        uint32_t * hex_a = &a;
        uint32_t * hex_b = &b;
        uint32_t * hex_c = &c;

        printf("%x %x %x\n", *hex_a , *hex_b , *hex_c );
    }
    
    // Done!
    //fclose(ifp);
    //fclose(ofp);
    printf("Wrote file %s\n", OUTFILE);
    
    
    printf("TEST!\n");
    return 0;
}

#else 
// positioning interval
// positioning interval
static const float T = 1;
static const float gps_data[5][16]= {
        {-11602023.9489137008786201,14063117.4931115992367268,18811434.3112745992839336,-20853271.5736341997981071,1806977.2118581600952893,16542682.1237923000007868,-14355926.0172339994460344,8650961.8841098193079233,20736354.9805863983929157,7475239.6753052901476622,12966181.2771377004683018,21931576.7921750992536545,23568206.4173782989382744,26183921.4577450007200241,24652215.2627705000340939,25606982.9330466017127037},
        {-11602700.4096150007098913,14060708.1637619994580746,18812823.4023028016090393,-20855049.9291185997426510,1805887.1306580700911582,16540582.4659656994044781,-14356344.1729805991053581,8648384.4768619798123837,20737164.3397033996880054,7472917.3215693095698953,12967714.4596338998526335,21931442.6029887981712818,23568427.7909861989319324,26184404.1127416007220745,24652621.9011856988072395,25606499.4748000986874104},
        {-11603377.0261803008615971,14058298.6961425002664328,18814212.0761809013783932,-20856828.1167653985321522,1804797.2804981300141662,16538482.4609003998339176,-14356762.4791433997452259,8645806.9947465099394321,20737973.2627678997814655,7470595.0720982002094388,12969247.7736987993121147,21931307.9468086995184422,23568650.0894557014107704,26184884.7086125016212463,24653025.2764103002846241,25606016.6971120014786720},
        {-11604053.7986267991364002,14055889.0902858991175890,18815600.3328956998884678,-20858606.1364935003221035,1803707.6613832199946046,16536382.1086646001785994,-14357180.9357223007827997,8643229.4378561992198229,20738781.7497542984783649,7468272.9269468197599053,12970781.2192928008735180,21931172.8236371017992496,23568869.5260895006358624,26185366.6481501981616020,24653428.8435873985290527,25605534.4603805989027023},
        {-11604730.7269448004662991,14053479.3463228996843100,18816988.1723781004548073,-20860383.9882667995989323,1802618.2732910700142384,16534281.4092740993946791,-14357599.5427193008363247,8640651.8062730506062508,20739589.8006406985223293,7465950.8861416298896074,12972314.7963951993733644,21931037.2334740012884140,23569094.4420915991067886,26185845.7782028988003731,24653834.8537949994206429,25605048.9604584984481335}
    };

static void blkfill(ekf_t * ekf, const float * a, int off)
{
    off *= 2;

    ekf->Q[off]   [off]   = a[0]; 
    ekf->Q[off]   [off+1] = a[1];
    ekf->Q[off+1] [off]   = a[2];
    ekf->Q[off+1] [off+1] = a[3];
}


static void init(ekf_t * ekf)
{
    // Set Q, see [1]
    const float Sf    = 36;
    const float Sg    = 0.01;
    const float sigma = 5;         // state transition variance
    const float Qb[4] = {Sf*T+Sg*T*T*T/3, Sg*T*T/2, Sg*T*T/2, Sg*T};
    const float Qxyz[4] = {sigma*sigma*T*T*T/3, sigma*sigma*T*T/2, sigma*sigma*T*T/2, sigma*sigma*T};

    blkfill(ekf, Qxyz, 0);
    blkfill(ekf, Qxyz, 1);
    blkfill(ekf, Qxyz, 2);
    blkfill(ekf, Qb,   3);

    // initial covariances of state noise, measurement noise
    float P0 = 10;
    float R0 = 36;

    int i;

    for (i=0; i<8; ++i)
        ekf->P[i][i] = P0;

    for (i=0; i<4; ++i)
        ekf->R[i][i] = R0;

    // position
    ekf->x[0] = -2.168816181271560e+006;
    ekf->x[2] =  4.386648549091666e+006;
    ekf->x[4] =  4.077161596428751e+006;

    // velocity
    ekf->x[1] = 0;
    ekf->x[3] = 0;
    ekf->x[5] = 0;

    // clock bias
    ekf->x[6] = 3.575261153706439e+006;

    // clock drift
    ekf->x[7] = 4.549246345845814e+001;
    int j;
    for (j=0; j<8; ++j)
        ekf->F[j][j] = 1;

    for (j=0; j<4; ++j)
        ekf->F[2*j][2*j+1] = T;
}

static void model(ekf_t * ekf, float SV[4][3])
{ 

    int i, j;

    for (j=0; j<8; j+=2) {
        ekf->fx[j] = ekf->x[j] + T * ekf->x[j+1];
        ekf->fx[j+1] = ekf->x[j+1];
    }

    

    float dx[4][3];

    for (i=0; i<4; ++i) {
        ekf->hx[i] = 0;
        for (j=0; j<3; ++j) {
            float d = ekf->fx[j*2] - SV[i][j];
            dx[i][j] = d;
            ekf->hx[i] += d*d;
        }
        ekf->hx[i] = powf(ekf->hx[i], 0.5) + ekf->fx[6];
    }

    for (i=0; i<4; ++i) {
        for (j=0; j<3; ++j) 
            ekf->H[i][j*2]  = dx[i][j] / ekf->hx[i];
        ekf->H[i][6] = 1;
    }   
}

static void readline(char * line, FILE * fp)
{
    fgets(line, 1000, fp);
}

static void readdata(float SV_Pos[4][3], float SV_Rho[4], int n)
{
    //char line[1000];

    //readline(line, fp);

    //char * p = strtok(line, ",");

    int i, j;

    for (i=0; i<4; ++i)
        for (j=0; j<3; ++j) {
            SV_Pos[i][j] = gps_data[n][(4 * i) + j];
            //p = strtok(NULL, ",");
        }

    for (j=0; j<4; ++j) {
        SV_Rho[j] = gps_data[n][12 + j];
        //p = strtok(NULL, ",");
    }
}


/*static void skipline(FILE * fp)
{
    char line[1000];
    readline(line, fp);
}*/

void error(const char * msg)
{
    fprintf(stderr, "%s\n", msg);
}

int main(int argc, char ** argv)
{    
    
    // Do generic EKF initialization
    ekf_t ekf;
    ekf_init(&ekf, Nsta, Mobs);

    // Do local initialization
    init(&ekf);

    // Open input data file
    //FILE * ifp = fopen("gps.csv", "r");

    // Skip CSV header
    //skipline(ifp);
    
    // Make a place to store the data from the file and the output of the EKF
    float SV_Pos[4][3];
    float SV_Rho[4];
    float Pos_KF[25][3];

    // Open output CSV file and write header
    const char * OUTFILE = "ekf.csv";
    //FILE * ofp = fopen(OUTFILE, "w");
    //fprintf(ofp, "X,Y,Z\n");
    printf("begin software: \n");
    int j, k;

    // Loop till no more data
    for (j=0; j<5; ++j) {
        printf("Doing Step: %d\n", j);

        readdata(SV_Pos, SV_Rho, j);

        model(&ekf, SV_Pos);

        ekf_step(&ekf, SV_Rho);

        // grab positions, ignoring velocities
        for (k=0; k<3; ++k)
            Pos_KF[j][k] = ekf.x[2*k];
    }

    // Compute means of filtered positions
    float mean_Pos_KF[3] = {0, 0, 0};
    for (j=0; j<5; ++j) 
        for (k=0; k<3; ++k)
            mean_Pos_KF[k] += Pos_KF[j][k];
    for (k=0; k<3; ++k)
        mean_Pos_KF[k] /= 5;


    // Dump filtered positions minus their means
    for (j=0; j<5; ++j) {
        float a = (Pos_KF[j][0] - mean_Pos_KF[0]);
        float b = (Pos_KF[j][1] - mean_Pos_KF[1]);
        float c = (Pos_KF[j][2] - mean_Pos_KF[2]);
        uint32_t * hex_a = &a;
        uint32_t * hex_b = &b;
        uint32_t * hex_c = &c;

        printf("%x %x %x\n", *hex_a , *hex_b , *hex_c );
    }
    
    // Done!
    //fclose(ifp);
    //fclose(ofp);
    printf("Wrote file %s\n", OUTFILE);
    
    
    printf("TEST!\n");
    return 0;
}
#endif
