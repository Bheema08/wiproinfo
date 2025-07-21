using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace Helloworld
{
    internal class Caluclator
    {
        static void Main()
        {
            int a, b, c;
            Console.WriteLine("Enter two numbers ");
            a=Convert.ToInt32(Console.ReadLine());
            b=Convert.ToInt32(Console.ReadLine());
            c = a + b;
            Console.WriteLine("Sum is "+c);
            c = a - b;
            Console.WriteLine("sub is "+c);
            c = a * b;
            Console.WriteLine("product is "+c);
        }
    }
}
