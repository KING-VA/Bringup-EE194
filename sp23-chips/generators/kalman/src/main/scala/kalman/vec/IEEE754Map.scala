package kalman.vec

/**
 * Given the size of a floating point number, return the number of exponent
 * and significant bits for a IEEE 754 float that size, in hardfloat's recoded
 * form.
 *
 * @note This is **only** for use with hardfloat's encoded numbers.
 */
object IEEE754Map {
  /**
   * @param f size of IEEE 754 float (16, 32, 64)
   * @return number of exponent bits in hardfloat recoded form
   */
  def exp(f: Int) = f match {
    case 16 => 5
    case 32 => 8
    case 64 => 11
  }

  /**
   * @param f size of IEEE 754 float (16, 32, 64)
   * @return number of exponent bits in hardfloat recoded form
   */
  def sig(f: Int) = f match {
    case 16 => 11
    case 32 => 24
    case 64 => 53
  }
}
