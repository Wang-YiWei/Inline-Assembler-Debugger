import pyd.pyd;
import pyd.embedded;
import pyd.extra;
import std.stdio;
import std.file;
import std.range;

immutable plot_script = import("show_histogram.py");

shared static this() {
	// shared static constructor 在 d 語言會先被執行，
	// 我們可以在這裡先初始化 shared global data

	//initializes PyD package.
	py_init();
}

int set_asm_fib_value(int val)
{
    int my_reg_val;
    
    asm
    {
        // 透過EBP來找stack variable
        mov EAX,val[EBP] ;
        mov my_reg_val[EBP],EAX ;
    }

    return my_reg_val;
}

void main()
{
	int [] x_range = [];
	int [] y_range = [];
	
	int i;
	int y_val = 0;
	int my_reg_val = 0;

	for(i = 0; i <= 100; i++, y_val++)
	{
		x_range ~= i;
		// 第80次給予異常值
		y_range ~= (y_val == 80) ? y_val + 15 : y_val;
	}

	// 設定視覺化的參數 
	auto pythonContext = new InterpContext();

	pythonContext.x_val = x_range;
	pythonContext.y_val = y_range;	
    pythonContext.py_stmts(plot_script);

}

double[] readData(string file)
{
	// 讀檔 

	import std.algorithm.iteration : map, splitter;
	import std.array : array;
	import std.conv : to;
	import std.file : readText;

	// 這邊用UFCS會簡潔許多	
	return file
		.readText   // Reads the contents of a text file into a string.
		.splitter        // Lazily splits words.
		.map!(to!double) // Lazily converts words to doubles.
		.array;          // Creates an array.
}
