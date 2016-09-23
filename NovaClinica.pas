{
Sistema para Consultorios
Versão: 2.0
Criadores: Tarcisio Ambrosio, Bruno Vargas, Marcos Gonçalves
}

Program Pzim ;
type
pessoa= record
  id:integer;
  nome:string;
  cpf:string;
endereco:string;
telefone:string;
end;

type
medico=record
  pessoa:pessoa;
  crm:string;
end;

type
paciente=record
  sintomas:string;
  pessoa:pessoa;
end;

type
consulta=record
  quadro:string;
  data:string;
  medico:medico;
  paciente:paciente;
end;

type
AConsultas = array[1..100] of consulta;
APessoas = array[1..100] of pessoa;
APacientes = array[1..100] of paciente;
AMedicos = array[1..100] of medico;

var
pacientes:APacientes;
pessoas:APessoas;
medicos:AMedicos;
consultas:AConsultas;
menu_principal:char;
termos:string;
p:paciente;
m:medico;
c:consulta;



{
Simples tela de CARREGANDO....
}

Procedure carregando(x,y,tempo_total_milissegundos:integer;mensagem:string);
var aux, x_barras:integer;
Begin
  x_barras:=x+15;
  for aux:=1 to 100 do
  begin
    delay(tempo_total_milissegundos DIV 100);
    Gotoxy(x,y);
    Write(mensagem,' (',aux,'%) ');
    If (aux=15) or (aux=30) or (aux=45) or (aux=60) or (aux=75) or (aux=90) or (aux=100) then
    begin
      x_barras:=x_barras+2;
      Gotoxy(x_barras,y);
      Write(#219);
    end;
  End;
End;

{
Retorna a posição do último registro de pessoas
}
function getLastIndexOfMedicos(medicos:AMedicos):integer;
var
i:integer;
last_index:integer;

begin
  last_index:= 1;
  for i:=1 to 100 do
  begin
    if(medicos[i].pessoa.nome = '') then
    begin
      last_index:=i;
      break;
    end;
  end;
  
  getLastIndexOfMedicos:=last_index;
end;


{
Retorna a posição do último registro de pessoas
}
function getLastIndexOfPacientes(pacientes:APacientes):integer;
var
i:integer;
last_index:integer;

begin
  last_index:= 1;
  for i:=1 to 100 do
  begin
    if(pacientes[i].pessoa.nome = '') then
    begin
      last_index:=i;
      break;
    end;
  end;
  
  getLastIndexOfPacientes:=last_index;
end;



{
Retorna a posição do último registro de consultas
}
function getLastIndexOfConsultas(consultas:AConsultas):integer;
var
i:integer;
last_index:integer;

begin
  last_index:= 1;
  for i:=1 to 100 do
  begin
    if(consultas[i].data = '') then
    begin
      last_index:=i;
      break;
    end;
  end;
  
  getLastIndexOfConsultas:=last_index;
end;



{
Cadastrando Pacientes e utilizando contador automático
}
procedure CadastrarPaciente(var pacientes:APacientes);
var
last_index:integer;
continua:string;
begin
  last_index:=getLastIndexOfPacientes(pacientes);
  while((last_index < 100) and (continua <> 'n') and (continua <> 'N')) do
  begin
    clrscr;
    writeln('-----Cadastro de Paciente [',last_index,']-----');
    write('Digite o nome: '); readln(pacientes[last_index].pessoa.nome);
    write('Digite o CPF: '); readln(pacientes[last_index].pessoa.cpf);
    write('Digite o Telefone: '); readln(pacientes[last_index].pessoa.telefone);
  write('Digite o Endereço: '); readln(pacientes[last_index].pessoa.endereco);
  write('Digite os Sintomas do Paciente: '); readln(pacientes[last_index].sintomas);
  writeln('');
  repeat
    clrscr;
    writeln('Continuar cadastrando?');
    writeln('Digite S ou s para sim');
    writeln('Digite N ou n para não');
    write('Escolha: ');
    readln(continua);
    last_index:=getLastIndexOfPacientes(pacientes);
  until((continua = 'n') or (continua = 'N') or (continua = 's') or (continua = 'S'));
  
end;
clrscr;
end;


{
Cadastrando Pacientes e utilizando contador automático
}
procedure CadastrarMedico(var pacientes:AMedicos);
var
last_index:integer;
continua:string;
begin
  last_index:=getLastIndexOfMedicos(medicos);
  while((last_index < 100) and (continua <> 'n') and (continua <> 'N')) do
  begin
    clrscr;
    writeln('-----Cadastro de Medico [',last_index,']-----');
    write('Digite o nome: '); readln(medicos[last_index].pessoa.nome);
    write('Digite o CPF: '); readln(medicos[last_index].pessoa.cpf);
    write('Digite o Telefone: '); readln(medicos[last_index].pessoa.telefone);
    write('Digite o CRM: '); readln(medicos[last_index].crm);
  write('Digite o Endereço: '); readln(medicos[last_index].pessoa.endereco);
  writeln('');
  repeat
    clrscr;
    writeln('Continuar cadastrando?');
    writeln('Digite S ou s para sim');
    writeln('Digite N ou n para não');
    write('Escolha: ');
    readln(continua);
    last_index:=getLastIndexOfMedicos(medicos);
  until((continua = 'n') or (continua = 'N') or (continua = 's') or (continua = 'S'));
  
end;
clrscr;
end;


{
Consultar Paciente
}

function getPacienteByTermos(pacientes:APacientes;termos:string):paciente;
var
i:integer;
continua:char;
p:paciente;
begin
  clrscr;
  begin
    for i:= 1 to 100 do
    begin
      if(pos(termos, pacientes[i].pessoa.nome) > 0) then
      begin
        clrscr;
        writeln('------------------------------------');
        writeln('Paciente Encontrado');
        writeln('Nome -> ',pacientes[i].pessoa.nome);
        writeln('------------------------------------');
        
        repeat
          writeln('Deseja utilizar este paciente ou continuar procurando?');
          writeln('ESPAÇO -> Próximo');             //' '
          writeln('ENTER -> Selecionar Atual');    //#13
          writeln('ESC -> Sair sem Selecionar');      //#27
          continua := readkey;
          case continua of
            ' ': begin
            end;
            #13: begin
              p:=pacientes[i];
            end;
            #27: begin
              break;
            end;
          end;
          
        until((continua = #27) or (continua = #13) or (continua = ' '));
        if((continua = #27) or (continua = #13)) then
        break;
      end;
    end;
    
    clrscr;
    if(p.pessoa.nome <> '') then
    begin
      writeln('------------------------------------');
      writeln('Paciente SELECIONADO');
      writeln('Nome -> ',p.pessoa.nome);
      writeln('CPF -> ',p.pessoa.cpf);
      writeln('Telefone -> ',p.pessoa.telefone);
    writeln('Endereço -> ',p.pessoa.endereco);
    writeln('Sintomas -> ',p.sintomas);
    writeln('------------------------------------');
  end
  else
  begin
    writeln('Nenhum paciente foi selecionado ou encontrado');
  end;
  
  getPacienteByTermos:= p;
  writeln('Aperte qualquer tecla para continuar');
  readkey;
end;
end;





{
Consultar Paciente
}

function getMedicoByTermos(medicos:AMedicos;termos:string):medico;
var
i:integer;
continua:char;
m:medico;
begin
  clrscr;
  begin
    for i:= 1 to 100 do
    begin
      if(pos(termos, medicos[i].pessoa.nome) > 0) then
      begin
        clrscr;
        writeln('------------------------------------');
        writeln('Médico Encontrado');
        writeln('Nome -> ',medicos[i].pessoa.nome);
        writeln('------------------------------------');
        
        repeat
          writeln('Deseja utilizar este paciente ou continuar procurando?');
          writeln('ESPAÇO -> Próximo');             //' '
          writeln('ENTER -> Selecionar Atual');    //#13
          writeln('ESC -> Sair sem Selecionar');      //#27
          continua := readkey;
          case continua of
            ' ': begin
            end;
            #13: begin
              m:=medicos[i];
            end;
            #27: begin
              break;
            end;
          end;
          
        until((continua = #27) or (continua = #13) or (continua = ' '));
        if((continua = #27) or (continua = #13)) then
        break;
        
      end;
    end;
    
    clrscr;
    if(m.pessoa.nome <> '') then
    begin
      writeln('------------------------------------');
      writeln('Medico SELECIONADO');
      writeln('Nome -> ',m.pessoa.nome);
      writeln('CPF -> ',m.pessoa.cpf);
      writeln('Telefone -> ',m.pessoa.telefone);
    writeln('Endereço -> ',m.pessoa.endereco);
    writeln('CRM: -> ',m.crm);
    writeln('------------------------------------');
  end
  else
  begin
    writeln('Nenhum medico foi selecionado ou encontrado');
  end;
  
  getMedicoByTermos:= m;
  writeln('Aperte qualquer tecla para continuar');
  readkey;
end;
end;



{
Cadastrar Consulta
}

procedure CadastrarConsulta(pacientes:APacientes; medicos:AMedicos; var consultas:AConsultas);
var
last_index:integer;
continua:string;
termos:string;
p:paciente;
m:medico;

begin
  last_index:= 0;
  writeln('Primeiro Selecione um Paciente já cadastrado');
  repeat
    write('Localizar paciente por nome/CPF: ');
    readln(termos);
    if(termos = '') then
    writeln('Digite ao menos 1 caractere para efetuar a busca');
  until termos <> '';
  p:= getPacienteByTermos(pacientes,termos);
  if(p.pessoa.nome <> '') then
  begin
  writeln('Agora cadastre o médico que irá atender o Sr(a): ', p.pessoa.nome);
  repeat
    write('Localizar medico por nome/CRM: ');
    readln(termos);
    if(termos = '') then
    writeln('Digite ao menos 1 caractere para efetuar a busca');
  until termos <> '';
  m:= getMedicoByTermos(medicos,termos);
  if(m.pessoa.nome <> '') then
  begin
    last_index:= getLastIndexOfConsultas(consultas);
    consultas[last_index].paciente:= p;
    consultas[last_index].medico:=m;
    writeln('Digite a data da consulta: ');
    readln(consultas[last_index].data);
  end;
end;
if(last_index = 0) then
begin
  writeln('Consulta não salva por falta de dados do médico ou do paciente, faça o cadastro de ambos na tela principal');
end
else
begin
writeln('Consulta agendada com sucesso');
end;
writeln('Pressione qualquer teclada para voltar ao menu principal');
readkey;
end;



{
Listar Consultas
}

procedure ListarConsultas(consultas:AConsultas);
var
i:integer;
last_index:integer;
tem_consultas:boolean;
begin
  tem_consultas:=false;
  last_index:= getLastIndexOfConsultas(consultas);
  for i:= 1 to last_index do
  begin
    if(consultas[i].data <> '') then
    begin
      tem_consultas:= true;
      writeln('---------------------');
    writeln('Consulta Agendada');
    writeln('Paciente: ', consultas[i].paciente.pessoa.nome);
    writeln('Médico: ', consultas[i].medico.pessoa.nome);
    writeln('Data: ', consultas[i].data);
    writeln('');
  end;
end;

if(tem_consultas = false) then
writeln('Não existem consultas agendadas');

writeln('Pressione qualquer tecla para voltar ao menu principal');
readkey;


end;

{
INICIALIZADOR
}

Begin
  carregando(2,2,1000,'Carregando Programa'); //aparecer o carregando...
  repeat
    menu_principal := '0';
    clrscr;
    writeln('------- MENU PRINCIPAL ------');
    writeln('1) Cadastrar Paciente');
    writeln('2) Cadastrar Médico');
    writeln('3) Buscar Paciente');
    writeln('4) Buscar Médico');
    writeln('5) Cadastrar Consulta');
    writeln('6) Listar Consultas');
    writeln('-----------------------------');
    writeln('0) SAIR DO PROGRAMA');
    writeln('-----------------------------');
    write('Menu Selecionado(0 até 6): ');
    readln(menu_principal);
    
    
    CASE menu_principal OF
      '1' : BEGIN
        CadastrarPaciente(pacientes);
      END;
      
      '2' : BEGIN
        CadastrarMedico(medicos);
      END;
      
      
      '3' : BEGIN
        clrscr;
        repeat
          write('Digite os termos para busca(Nome ou CPF): ');
          readln(termos);
          if(termos = '') then
          writeln('Digite ao menos 1 caractere para efetuar a busca');
        until termos <> '';
        p:=getPacienteByTermos(pacientes, termos);
      END;
      
      
      '4' : BEGIN
        clrscr;
        repeat
          write('Digite os termos para busca(Nome ou CRM): ');
          readln(termos);
          if(termos = '') then
          writeln('Digite ao menos 1 caractere para efetuar a busca');
        until termos <> '';
        m:=getMedicoByTermos(medicos, termos);
      END;
      
      '5' : BEGIN
        clrscr;
        CadastrarConsulta(pacientes, medicos, consultas);
        
      END;
      
      '6' : BEGIN
        clrscr;
        ListarConsultas(consultas);
      END;
      
      '0': BEGIN
        clrscr;

        carregando(2,2,500,'Salvando Pacientes');
        carregando(2,3,500,'Salvando Médicos');
        carregando(2,4,500,'Salvando Consultas');				        
        carregando(2,5,500,'Fechando....');  
        writeln('');
				writeln('Aperte qualquer tecla para fechar esta janela');
				readkey;   
      END;
    END;
    
  until menu_principal = '0';
End.