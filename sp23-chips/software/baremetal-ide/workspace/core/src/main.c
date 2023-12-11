/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
void main() {
  /* USER CODE BEGIN 1 */
  
	/* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/
  
  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  /* USER CODE BEGIN 2 */
  // RCC->TILE0_RESET = 0;
  // RCC->TILE1_RESET = 0;
  // RCC->TILE2_RESET = 0;
  // RCC->TILE3_RESET = 0;

  uint32_t hart_id = READ_CSR("mhartid");
  for (uint32_t i=0; i<hart_id * 1000; i+=1) {}
  printf("hello world from %d\n", hart_id);

  for (uint32_t i=0; i<100000; i+=1) {}
  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
	while (1) {
		return 0;
		/* USER CODE END WHILE */
	}

	/* USER CODE BEGIN 3 */

	/* USER CODE END 3 */
}

void prefetcher_test_main() {
    /*unsigned int mmio_addr = 0x1000;
 *     unsigned int data = 1;
 *         asm ("sw %0, 0(%1)" : : "r"(data), "r"(mmio_addr)); //MAGICALLY STARTED WORKING DO NOT TOUCH*/

    uint8_t enable = 1;
    PREFETCHER->EN = enable;

    int array[1024];

    for (int i=0; i<1024; i++) {
        array[i] = 0;
    }

    enable = 0;
    PREFETCHER->EN = enable;

    int array2[1024];

    for (int i=0; i<1024; i++) {
        array2[i] = 0;
    }

    return 0;
}
