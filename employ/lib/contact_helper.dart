
final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";
final String tipoSangueColumn="tipoSangueColumn";
final String localizacaoColumn="localizacaoColumn";
final String tipoColumn="tipoColumn";
final String necessidadeColumn="necessidadeColumn";
final String unidadeColumn="unidadeColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Future<List> getAllContacts() async {

  }
}
class Contact {

  int id;
  String name;
  String email;
  String phone;
  String img;
  String tipoSangue;
  String localizacao;
  String tipo;
  int necessidade;
  String unidade;

  Contact();

  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
    tipoSangue = map[tipoSangueColumn];
    localizacao=map[localizacaoColumn];
    tipo=map[tipoColumn];
    necessidade=map[necessidadeColumn];
    unidade=map[unidadeColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img,
      tipoSangueColumn: tipoSangue,
      localizacaoColumn :localizacao,
      tipoColumn:tipo,
      necessidadeColumn:necessidade,
      unidadeColumn:unidade
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }
  Map toMap2() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img,
      tipoSangueColumn: tipoSangue,
      localizacaoColumn :localizacao,
      tipoColumn:tipo
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img ,Tipo_Sanguineo:$tipoSangue),Localização:$localizacao,Tipo:$tipo,Necessidade:$necessidade,Uniadade Hospitalar:$unidade ";
  }

}