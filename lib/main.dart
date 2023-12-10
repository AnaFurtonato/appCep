
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _inputCEP = TextEditingController();
  final _inputRua = TextEditingController();
  final _inputIBGE= TextEditingController();
  final _inputBairro = TextEditingController();
  final _inputCidade = TextEditingController();
  final _inputUF = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _labelButton = 'Consultar CEEP';

  

  double _resultado = 0;
  String _label = '';

  void getRequestCep(String aCep) async{
    try{
      var dio = Dio();
      dio.options.connectTimeout = Duration(seconds: 5);
      dio.options.connectTimeout = Duration(seconds: 3);

      if (aCep.length != 8){
       setMsgErro('CEP Invalido', 'CEP deve possuir 8 digitos!');
       return;
      }

      setWaiting('Aguarde.....');
      var url = 'https://viacep.com.br/ws/$aCep/json/';
      var response = await dio.get(url);

      if(response.data['erro'] != null){
        setMsgErro('Erro ao consultar CEP', 'CEP não encontrado');
        setWaiting('Consultar CEP');
        return;
      }

     

      _inputRua.text = response.data['logradouro'].toUpperCase();
      _inputIBGE.text = response.data['ibge'];
      _inputBairro.text = response.data['bairro'].toUpperCase();
      _inputCidade.text = response.data['localidade'].toUpperCase();
      _inputUF.text = response.data['uf'].toUpperCase();

      setWaiting('Consultar CEP');
    } on Exception catch(erro){
      setWaiting('Consultar CEP');
      setMsgErro('Erro ao consultar CEP', erro.toString());
    }
  }

  void setMsgErro(String aTitulo, String aMessage){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(height: 15),
            Text(
              aTitulo,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          ],
        ),
        content: Text(
          aMessage,
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: const Text(
              "OK",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    });
  }

  void setWaiting(String aCaption){
    _labelButton = aCaption;
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/imagens/mapa.png',
                          width: 100,
                          height: 110,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _inputCEP,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          obscureText: false,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              labelText: 'CEP',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              counterStyle: TextStyle(color: Colors.white),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.yellow),
                              ),
                              errorStyle: TextStyle(
                                color: Colors.yellow,
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.yellow),
                              )),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                double.parse(value) <= 0) {
                              return 'Informe o CEP para a pesquisa';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                getRequestCep(_inputCEP.text);
                              }
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.map_outlined,
                                    color: Colors.black,
                                  ),
                                  Text(_labelButton,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      )),
                                ])),
                        GestureDetector(
                          onLongPress: () {
                            _inputCEP.clear();
                            _label = '';

                            setState(() {});
                          },
                          child: Text(
                            _label,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: _inputRua,
                          obscureText: false,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            prefixIcon: Text('Rua:'),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Color.fromARGB(255, 223, 223, 223),                            
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _inputIBGE,
                          obscureText: false,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            prefixIcon: Text('IBGE:'),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Color.fromARGB(255, 223, 223, 223),                            
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _inputBairro,
                          obscureText: false,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            prefixIcon: Text('Bairro:'),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Color.fromARGB(255, 223, 223, 223),
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _inputCidade,
                          obscureText: false,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            prefixIcon: Text('Cidade:'),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Color.fromARGB(255, 223, 223, 223),
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _inputUF,
                          obscureText: false,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            prefixIcon: Text('Estado:'),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Color.fromARGB(255, 223, 223, 223),
                          ),
                          readOnly: true,
                        ),
                      ],
                    )
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//readOnly: true = Não permite que o campo TextField seja digitado
//counterStyle: TextStyle(color: Colors.white) = deixa o contador de caracteres na cor branca
//fillColor = troca a cor do fundo do TextField, só que tem que colocar o filled como true
//labelStyle: TextStyle(color: Colors.black), = Troca a cor do text de dentro do TextField
//Para o validator do campo TextField funcionar precisa adicionar um if dentro do evento do botão. Exemplo: onPressed: () {if (_formKey.currentState?.validate() ?? false) {}}
//errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow),) = Define a cor da borda quando á erro, quando entra dentro do if do validator
//errorStyle: TextStyle(color: Colors.yellow,) = Define a cor do texto(return) da mensagem de erro, quando entra dentro do if do validator
//focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow),) = Define a cor da borda quando da foco e quando á erro, quando entra dentro do if do validator
//Void = Não retorna nada