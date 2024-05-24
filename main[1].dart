
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

void main()=> runApp(const MaterialApp(
  home:  NumberPad(),
));

class NumberPad extends StatefulWidget {
  const NumberPad({super.key});

  @override
  State<NumberPad> createState() => _NumberPadState();
}

class _NumberPadState extends State<NumberPad> {
  List<String> numbers_1 = [
    '7','4','1','0'
  ];  List<String> numbers_2 = [
    '8','5','2','.'
  ];  List<String> numbers_3 = [
    '9','6','3','='
  ];
  List<String> operations = [
    '*','+','/','-'
  ];
  String equation = "";
  String lastEntry = '';
  bool dotAvailable = true;

  void buildEquation(String entry){
    setState(() {
      int entryStatus = checkEntry(entry);
      int lastEntryStatus = checkEntry(lastEntry);

      if (entryStatus == 0 ){
        dotAvailable = true;
      }

      if (entryStatus == lastEntryStatus && entryStatus == 0){
        dotAvailable = true;
        if (lastEntry == entry){
          // nothing
        }
        else {
          // this will be costly over long time
          equation = equation.substring(0, equation.length - 1);
          equation += entry;
          lastEntry = entry;
        }

      }
      else if ((entryStatus == 0)) {
        {
          if (lastEntryStatus == 2 || lastEntryStatus == 3) {
            equation += entry;
            lastEntry = entry;
          }
          else{
            print('operation invalid');
          }
        }
      }
       else if ((entryStatus == 1) ){
       {
         if( lastEntryStatus == 2 && dotAvailable == true )
           {
             equation += entry;
             lastEntry = entry;
             dotAvailable = false;
           }
         else{
           print('operation invalid');
         }
       }

      }
      else if (entryStatus == 2){
        if (lastEntryStatus == 3)
          {
            equation = entry;
          }
        else{
          equation += entry;

        }
        lastEntry = entry;
      }
      else if (entryStatus == 3){
        lastEntry=entry;
        equation = (equation.interpret()).toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mini-Calculator"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(

                    color: Colors.grey,

                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text(equation, style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),)
                  ),
                )
              ],
            ),
          ),

          Expanded(
            flex: 10,
            child: Container(
              color: Colors.grey[800],
              margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildColumn(numbers_1 , buildEquation),
                    buildColumn(numbers_2 , buildEquation),
                    buildColumn(numbers_3 , buildEquation),
                    buildColumn(operations, buildEquation),
                    FloatingActionButton(onPressed: ()
                    {setState(() {
                      equation = "";
                      dotAvailable = true;
                      lastEntry = '';
                    });},
                        elevation: 0,
                      child: const Text('AC'),

                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
Container button(String key,Function press)
// Container button(String key)
{
  return Container(
    padding: const EdgeInsets.all(5),
    margin: const EdgeInsets.all(5),
    child: FloatingActionButton(
      onPressed: (){
        press(key);
      },
      elevation: 0,
      child: Text(key, style:const TextStyle(fontSize: 20))
    ),
  );
}

Column buildColumn(List<String> numbers, Function callback)
{
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: numbers.map((number) => button(number.toString(),callback)).toList(),
  );
}
int checkEntry(String entry){
  if(entry == '*' || entry == '/'|| entry == '+'|| entry == '-'){
    return 0;
  }
  else if (entry == '.'){
    return 1;
  }
  else if (entry == ''){
    return -1;
  }
  else if (entry == '='){
    return 3;
  }
  else{
    return 2;
  }
}