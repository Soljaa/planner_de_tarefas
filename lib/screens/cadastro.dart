import 'package:flutter/material.dart';
import '../databases/userDatabase.dart' as user_db;
import '../databases/taskboardDatabase.dart' as taskboard_db;

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  static const Color roxo = Color(0xFF6354B2);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crie uma conta"),
        centerTitle: true,
        backgroundColor: roxo,
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.65,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue, Colors.purple],
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Dados de Login", style: TextStyle(color: Colors.white, fontSize: 22),),
                        const SizedBox(height: 40),
                        TextField(
                          controller: _usernameController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          cursorColor: Colors.white,
                          decoration: const InputDecoration(
                            labelText: 'Nome do Usuário',
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 10),
                        
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          cursorColor: Colors.white,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: _passwordController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          cursorColor: Colors.white,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: _confirmPasswordController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          cursorColor: Colors.white,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirmar Senha',
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: () {
                            _register(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            textStyle: const TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text('Cadastrar', style: TextStyle(color: roxo),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ### Registra um novo usuário com base nos dados fornecidos.
  ///
  /// Este método realiza a verificação da correspondência de senhas e
  /// verifica se o e-mail já está registrado no aplicativo. Se a
  /// verificação for bem-sucedida, o usuário é cadastrado e um
  /// `AlertDialog` informativo é exibido. Caso contrário, uma mensagem
  /// de erro correspondente é mostrada ao usuário.
  ///
  /// Para utilizar este método, forneça o contexto (`context`) de onde você
  /// está chamando esta função.
  /// 
  /// ### Parâmetros:
  ///   - `context`: O contexto onde a operação de registro será executada.
  void _register(BuildContext context) async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Verificação do formato do e-mail usando expressão regular
    RegExp emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegExp.hasMatch(email)) {
      _showAlertDialog(context, "FORMATO DE E-MAIL INVÁLIDO!", "Por favor, insira um e-mail válido.");
      return;
    }

    if (password == confirmPassword) {
      // Verificação da senha usando expressão regular
      RegExp passwordRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,}$');
      if (!passwordRegExp.hasMatch(password)) {
        _showAlertDialog(context, "SENHA INVÁLIDA!", "A senha deve conter pelo menos:\n ➡️ 8 caracteres\n ➡️ uma letra minúscula\n ➡️ uma letra maiúscula\n ➡️ um dígito\n ➡️ um caractere especial.");
        return;
      }
      List<Map<String, dynamic>> infoUser = await user_db.getInfoUser(email);
      if (infoUser.isEmpty) {
        // Se não existir conta com esse e-mail, então crie essa conta inserindo no banco de dados do usuário
        user_db.inserirDados(username, email, password);
        
        List lista = [
          ["Trabalho", 0xFF7EB0D5],
          ["Saúde", 0xFFB2E061],
          ["Academia", 0xFFBD7EBE],
          ["Estudo", 0xFFFFB55A],
          ["Errand", 0xFFFFEE65],
          ["Outros", 0xFF6354B2]
        ];

        var users = await user_db.consultarDados();

        for (List item in lista) {
          taskboard_db.inserirDadosTaskBoard(item[0], item[0], users.last["id"], item[1]);
        }

        _showAlertDialog(context, "CADASTRADO!", "Você foi cadastrado com sucesso.");
      } else {
        // Caso exista conta com esse e-mail, emita um alerta
        _showAlertDialog(context, "EMAIL JÁ EXISTE!", "O email ${email} já está registrado. Por favor, insira um e-mail que não esteja cadastrado no aplicativo.");
      }
    } else {
      // Se as senhas não coincidirem, exiba um AlertDialog
      _showAlertDialog(context, "ERRO DE SENHA!", "'As senhas não coincidem. Por favor, tente novamente.'");
    }
  }

  /// ### Exibe um `AlertDialog` informativo.
  ///
  /// Este método cria e exibe um `AlertDialog` com um título e mensagem
  /// fornecidos.
  ///
  /// ### Parâmetros:
  ///   - `context`: O contexto onde o diálogo será exibido. Geralmente obtido
  ///     de `BuildContext` no local de chamada.
  ///   - `h1`: O título do [AlertDialog].
  ///   - `message`: A mensagem a ser exibida no [AlertDialog].
  void _showAlertDialog(BuildContext context, String h1, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(h1),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o AlertDialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
