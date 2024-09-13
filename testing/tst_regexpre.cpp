// Uses a regex to check if the input is a floating point number

#include <iostream>
#include <regex>
#include <string>

int main()
{
    std::string input;
    std::regex rr("((\\+|-)?[[:digit:]]+)(\\.(([[:digit:]]+)?))?((e|E)((\\+|-)?)[[:digit:]]+)?");
    // As long as the input is correct ask for another number
    while (true)
    {
        std::cout << "Give me a real number!\n";
        std::cin >> input;

        if (!std::cin)
            break;

        // Exit when the user inputs q
        if (input == "q")
        {
            break;
        }

        if (regex_match(input, rr))
        {
            std::cout << "float\n";
        }
        else
        {
            std::cout << "Invalid input\n";
        }
    }
}
// g++ tst_regexpre.cpp -o tst_regexpre
// ./tst_regexpre