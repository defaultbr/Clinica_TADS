program clinica;

uses crt,sysutils;

type
	pessoa= record
		nome:string;
		cpf:string;
		endereco:string;
		telefone:string;
end;

type
	medico=record
		pessoa:pessoa;
		registro:string;
	//	consulta:consulta;
end;

type
	paciente=record
		pessoa:pessoa;
	//	consulta:consulta;
end;

type
	consulta=record
		quadro:string;
		data:string;
		medico:pessoa;
end;

type
AConsultas = array[1..100] of consulta;
APessoas = array[1..100] of pessoa;
APacientes = array[1..100] of paciente;
AMedicos = array[1..100] of medico;



var
	menu:integer;
	sub_menu:integer;
	consultas:AConsultas;
	pessoas:APessoas;
	pacientes:APacientes;
	medicos:AMedicos;


procedure desenhar(texto:string; laterais:string; preenchimento:string; alinhado:boolean);
var
	total:integer;
	sobra:integer;
	i:integer;

begin
	total:=40;
	sobra:=total-length(texto);
	write(laterais);
	//writeln('Tota; ', total, 'textoL: ', length(texto), ' sobra: ', sobra);
	if(alinhado) then
	begin
		sobra:= sobra+1;
		for i:=0 to sobra do
			begin
			if(i=2) then
			write(texto)
			else
			write(preenchimento);
			end;
	end
	else
		begin
		for i:= 0 to sobra do
			begin
				if(i = (sobra DIV 2)) then
				begin
					write(texto);
				end;
				write(preenchimento);
			end;
		end;
	
	writeln(laterais);
end;




/////////////////////////CABEÇALHO
procedure cabecalho();
	begin
		desenhar('-','-','-', false);
		desenhar('Clinica', '-',' ', false);
		desenhar('','-','-', false);
	end;


////////////////////////////TRATAR MENU

function validaMenu(menu:string):boolean;
	var 
		pass:boolean;

	begin
		pass := false;
	if((menu = '1')
		or
		(menu = '2')
		or
		(menu = '3')
		or
		(menu = '4')
		or
		(menu = '5')
		or
		(menu = '6')
		or
		(menu = '7')
		or
		(menu = '8')
		or				
		(menu = '9')) then
			pass:=true
		else
			pass:=false;

	validaMenu:=pass;
	end;


////////////////////////////CADASTRAR MEDICOS

procedure cadastrarMedico(var medicos:AMedicos);
	var 
		qtd:integer;
		i:integer;
		nome:string;
		continua:boolean;
		decisao:char;

	begin
		decisao:= #12;
		continua:=true;
		ClrScr;
		repeat
			write('Digite a quantidade de medicos que deseja cadastrar(MAX: 10): ');
			readln(qtd);
		until ((qtd >= 1) and (qtd <11));

		for i:= 1 to qtd do 
			begin

			if(continua) then
				begin
				ClrScr;
				nome := 'Digite o dados do medico ' + (IntToStr(i));
				desenhar(nome, '-', '-', true);
				write('Digite o nome: ');
				readln(medicos[i].pessoa.nome);
				write('Digite o cpf: ');
				readln(medicos[i].pessoa.cpf);
				write('Digite o endereço: ');
				readln(medicos[i].pessoa.endereco);
				write('Digite o telefone: ');
				readln(medicos[i].pessoa.telefone);
				desenhar('-', '-','-', false);
				desenhar('[Enter] Continua', '-',' ', true);
				desenhar(' [ESC]  Finaliza ', '-',' ', true);
				desenhar('-', '-','-', false);
			if(qtd > 1) then
				begin
				decisao:= readkey;
				if(decisao = #27) then
					continua := false
					else
					continua := true;

				end;

				ClrScr;

			end;

			end;
	end;


////////////////////////////CADASTRAR PACIENTES

procedure cadastrarPaciente(var pessoas:APacientes);
	var 
		qtd:integer;
		i:integer;
		nome:string;
		continua:boolean;
		decisao:char;

	begin
		decisao:= #12;
		continua:=true;
		ClrScr;
		repeat
			write('Digite a quantidade de pessoas que deseja cadastrar(MAX: 10): ');
			readln(qtd);
		until ((qtd >= 1) and (qtd <11));

		for i:= 1 to qtd do 
			begin

			if(continua) then
				begin
				ClrScr;
				nome := 'Digite o dados da pessoa ' + (IntToStr(i));
				desenhar(nome, '-', '-', true);
				write('Digite o nome: ');
				readln(pacientes[i].pessoa.nome);
				write('Digite o cpf: ');
				readln(pacientes[i].pessoa.cpf);
				write('Digite o endereço: ');
				readln(pacientes[i].pessoa.endereco);
				write('Digite o telefone: ');
				readln(pacientes[i].pessoa.telefone);
				desenhar('-', '-','-', false);
				desenhar('[Enter] Continua', '-',' ', true);
				desenhar(' [ESC]  Finaliza ', '-',' ', true);
				desenhar('-', '-','-', false);
			if(qtd > 1) then
				begin
				decisao:= readkey;
				if(decisao = #27) then
					continua := false
					else
					continua := true;

				end;

				ClrScr;

			end;

			end;
	end;



////////////////////////////LISTAR MEDICOS

procedure listarMedicos(medicos:AMedicos);
	var 
		i:integer;
		count:integer;
	begin
		ClrScr;
		count:=0;
		for i:= 1 to 100 do
			begin
				if(length(medicos[i].pessoa.nome)>0) then
					begin
						desenhar('-','-','-',false);
						desenhar(' Medico ' + IntToStr(i) + ' ', '-', ' ',false);
						desenhar('Nome: ' + medicos[i].pessoa.nome + ' ','-',' ',true);
						desenhar('CPF: ' + medicos[i].pessoa.cpf + ' ','-',' ',true);
						desenhar('Endereco: ' + medicos[i].pessoa.endereco + ' ','-',' ',true);
						desenhar('Telefone: ' + medicos[i].pessoa.telefone + ' ','-',' ',true);
						desenhar('-','-','-',false);
						count:=count+1;
						writeln('');
					end;
			end;

			writeln('');

		if(count = 0) then
			begin
				desenhar('-','-','-', false);
				desenhar(' 0 Medicos cadastrados ','-',' ', true);
				desenhar('-','-','-', false);
			end;

				desenhar('-','-','-', false);
				desenhar(' Pressione enter para voltar ','-',' ', true);
				desenhar('-','-','-', false);
				readkey;
	end;



////////////////////////////LISTAR PACIENTES

procedure listarPacientes(pacientes:APacientes);
	var 
		i:integer;
		count:integer;
	begin
		ClrScr;
		count:=0;
		for i:= 1 to 100 do
			begin
				if(length(pacientes[i].pessoa.nome)>0) then
					begin
						desenhar('-','-','-',false);
						desenhar(' Paciente ' + IntToStr(i) + ' ', '-', ' ',false);
						desenhar('Nome: ' + pacientes[i].pessoa.nome + ' ','-',' ',true);
						desenhar('CPF: ' + pacientes[i].pessoa.cpf + ' ','-',' ',true);
						desenhar('Endereco: ' + pacientes[i].pessoa.endereco + ' ','-',' ',true);
						desenhar('Telefone: ' + pacientes[i].pessoa.telefone + ' ','-',' ',true);
						desenhar('-','-','-',false);
						count:=count+1;
						writeln('');
					end;
			end;

			writeln('');

		if(count = 0) then
			begin
				desenhar('-','-','-', false);
				desenhar(' 0 Pacientes cadastrados ','-',' ', true);
				desenhar('-','-','-', false);
			end;

				desenhar('-','-','-', false);
				desenhar(' Pressione enter para voltar ','-',' ', true);
				desenhar('-','-','-', false);
				readkey;
	end;


////////////////////////////MOSTRAR MENU

procedure mostrarMenu(var pessoas:APessoas; var pacientes:APacientes; var medicos:AMedicos; var consultas:AConsultas);
	var 
		menu_validado:boolean;
		menu_temp:char;
		menu:integer;

	begin
		menu_validado := false;
	repeat
	ClrScr;
	cabecalho();
	desenhar('','-','-', false);
	desenhar('','|',' ', false);
	desenhar('1) Cadastrar Pessoas', '|',' ', true);
	desenhar('2) Cadastrar Medico', '|',' ', true);
	desenhar('3) Buscar Paciente', '|',' ', true);
	desenhar('4) Buscar Medico', '|',' ', true);
	desenhar('5) Marcar Consulta', '|',' ', true);
	desenhar('6) Consultas Marcadas', '|',' ', true);
	desenhar('7) Listar Pacientes', '|',' ', true);
	desenhar('8) Listar Medicos', '|',' ', true);
	desenhar('','|',' ', false);	
	desenhar('','-','-', false);
	desenhar('9) Fechar Programa', '|',' ', true);
	desenhar('','-','-', false);
	write('Digite uma opção: ');
	// readln(menu_temp);
	menu_temp := readkey;
	menu_validado := validaMenu(menu_temp);
	repeat
	if(menu_validado = false) then
		begin
			write('Deve ser digitado um menu entre 1 e 9: ');
			readln(menu_temp);
			menu_validado := validaMenu(menu_temp);
		end;
	until (menu_validado = true);
	ClrScr;


Case menu_temp of
		'1' : Begin
			cadastrarPaciente(pacientes);
			//Cadastrar Paciente

			End;
		'2' : Begin
			//Cadastrar Medico
			cadastrarMedico(medicos);

			End;

		'3' : Begin
			//Buscar Paciente
			

			End;

		'4' : Begin
			//Buscar Medico

			End;						


		'5' : Begin
			//Marcar Consulta

			End;


		'6' : Begin
			//Consultas Marcadas

			End;


			
		'7' : Begin
			//Listar Pacientes
			listarPacientes(pacientes);

			End;


		'8' : Begin
			//Listar Médicos
			listarMedicos(medicos);

			End;
	End; {CASE}

	


	until menu_temp = '9';

	// delay(5000);


	end;


Procedure Loading_screen(x,y,tempo_total_segundos:integer);
var aux,tempo_total_milissegundos, x_barras:integer;
Begin
  x_barras:=x+15;
  for aux:=1 to 100 do
  begin
	tempo_total_milissegundos:=tempo_total_segundos*1000;
	delay(tempo_total_milissegundos DIV 100);
	Gotoxy(x,y);
	Write('Carregando programa (',aux,'%) ');
	If (aux=15) or (aux=30) or (aux=45) or (aux=60) or (aux=75) or (aux=90) or (aux=100) then
	begin
	  x_barras:=x_barras+2;
	  Gotoxy(x_barras,y);
	  Write(#219);
	end;
  End;
End;


BEGIN
// cabecalho();
Loading_screen(2,2,1);
mostrarMenu(pessoas, pacientes, medicos, consultas);
writeln('');
END.
