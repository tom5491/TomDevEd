@isTest
public class CalculatorTest {
    static testMethod void additionTest(){
        Integer result = Calculator.Addition(2, 2);
        System.assertEquals(4, result, 'Does not equal 4');
    }
    static testMethod void multiplicationTest(){
        Integer result = Calculator.Multiplication(4, 2);
        System.assertEquals(8, result, 'Does not equal 8');
    }
}