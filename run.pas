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
		(menu = '9')) then
			pass:=true
		else
			pass:=false;

	validaMenu:=pass;
	end;


////////////////////////////CADASTRAR PACIENTES

procedure cadastrarPessoas(var pessoas:APessoas);
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
				readln(pessoas[i].nome);
				write('Digite o cpf: ');
				readln(pessoas[i].cpf);
				write('Digite o endereço: ');
				readln(pessoas[i].endereco);
				write('Digite o telefone: ');
				readln(pessoas[i].telefone);
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



////////////////////////////MOSTRAR MENU

procedure mostrarMenu(var pessoas:APessoas; var pacientes:APacientes; var medicos:AMedicos; var consultas:AConsultas);
	var 
		menu_validado:boolean;
		menu_temp:char;
		menu:integer;

	begin
		menu_validado := false;
	repeat

	desenhar('','-','-', false);
	desenhar('','|',' ', false);
	desenhar('1) Cadastrar Pessoas', '|',' ', true);
	desenhar('2) Cadastrar Medico', '|',' ', true);
	desenhar('3) Marcar Consulta', '|',' ', true);
	desenhar('4) Consultas Marcadas', '|',' ', true);
	desenhar('5) Listar Pacientes', '|',' ', true);
	desenhar('6) Listar Medicos', '|',' ', true);
	desenhar('','|',' ', false);	
	desenhar('','-','-', false);
	desenhar('9) Fechar Programa', '|',' ', true);
	desenhar('','-','-', false);
	write('Digite uma opção: ');
	readln(menu_temp);
	
	menu_validado := validaMenu(menu_temp);
	repeat
	if(menu_validado = false) then
		begin
			write('Deve ser digitado um menu entre 1 e 6 ou 9 para fechar: ');
			readln(menu_temp);
			menu_validado := validaMenu(menu_temp);
		end;
	until (menu_validado = true);
	ClrScr;


Case menu_temp of
		'1' : Begin
			cadastrarPessoas(pessoas);
			//Cadastrar Paciente

			End;
		'2' : Begin
			//Cadastrar Medico

			End;


		'3' : Begin
			//Marcar Consulta

			End;


		'4' : Begin
			//Consultas Marcadas

			End;


			
		'5' : Begin
			//Listar Pacientes

			End;


		'6' : Begin
			//Listar Médicos

			End;
	End; {CASE}

	


	until menu_temp = '9';
	end;



BEGIN
cabecalho();
mostrarMenu(pessoas, pacientes, medicos, consultas);



writeln('');
END.
