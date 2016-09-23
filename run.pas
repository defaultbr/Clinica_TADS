program clinica;

uses crt, SysUtils;

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
		paciente:pessoa;
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
//	total:=40;
//	sobra:=total-length(texto);
//	write(laterais);
//	//writeln('Tota; ', total, 'textoL: ', length(texto), ' sobra: ', sobra);
//	if(alinhado) then
//	begin
//		sobra:= sobra+1;
//		for i:=0 to sobra do
//			begin
//			if(i=2) then
//			write(texto)
//			else
//			write(preenchimento);
//			end;
//	end
//	else
//		begin
//		for i:= 0 to sobra do
//			begin
//				if(i = (sobra DIV 2)) then
//				begin
//					write(texto);
//				end;
//				write(preenchimento);
//			end;
//		end;
//	
//	writeln(laterais);
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
	if(
		(menu = '9')
		or
		(menu = '0')
		or

		(menu = '1')
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
		)
	then
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
				medicos[i].pessoa.id := i;
				nome := 'Digite os dados do medico ' + (IntToStr(i));
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
				pacientes[i].pessoa.id := i;
				nome := 'Digite os dados da pessoa ' + (IntToStr(i));
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

function listarMedicos(medicos:AMedicos; termos:string;show:boolean):integer;
	var 
		i:integer;
		count:integer;
	begin
		count:=0;
		for i:= 1 to 100 do
					Begin
				if(length(termos) > 0) then
					begin
						if(pos(termos,medicos[i].pessoa.nome) > 0) then
							begin
							if(show) then
								begin							
							desenhar('-','-','-',false);
							desenhar(' Medico ' + IntToStr(i) + ' ', '-', ' ',false);
							desenhar('Nome: ' + medicos[i].pessoa.nome + ' ','-',' ',true);
							desenhar('CPF: ' + medicos[i].pessoa.cpf + ' ','-',' ',true);
							desenhar('Endereco: ' + medicos[i].pessoa.endereco + ' ','-',' ',true);
							desenhar('Telefone: ' + medicos[i].pessoa.telefone + ' ','-',' ',true);
							desenhar('-','-','-',false);
							writeln('');
								end;
								count:=count+1;
							end;

					end
				else 
					begin
						if(length(medicos[i].pessoa.nome)>0) then
							begin
							if(show) then
								begin							
							desenhar('-','-','-',false);
							desenhar(' Medico ' + IntToStr(i) + ' ', '-', ' ',false);
							desenhar('Nome: ' + medicos[i].pessoa.nome + ' ','-',' ',true);
							desenhar('CPF: ' + medicos[i].pessoa.cpf + ' ','-',' ',true);
							desenhar('Endereco: ' + medicos[i].pessoa.endereco + ' ','-',' ',true);
							desenhar('Telefone: ' + medicos[i].pessoa.telefone + ' ','-',' ',true);
							desenhar('-','-','-',false);
							writeln('');							
							end;
							count:=count+1;
							end;
					end;
			end;

			writeln('');

			listarMedicos := count;
		

				
	end;



////////////////////////////LISTAR PACIENTES

function listarPacientes(pacientes:APacientes; termos:string;show:boolean):integer;
	var 
		i:integer;
		count:integer;
	begin
		count:=0;
		for i:= 1 to 100 do
			Begin
				if(length(termos) > 0) then
					begin
						if(pos(termos,pacientes[i].pessoa.nome) > 0) then
							begin
							if(show) then
								begin
							desenhar('-','-','-',false);
							desenhar(' ID: ' + IntToStr(i) + ' ', '-', ' ',false);
							desenhar(' Paciente ' + IntToStr(i) + ' ', '-', ' ',false);
							desenhar('Nome: ' + pacientes[i].pessoa.nome + ' ','-',' ',true);
							desenhar('CPF: ' + pacientes[i].pessoa.cpf + ' ','-',' ',true);
							desenhar('Endereco: ' + pacientes[i].pessoa.endereco + ' ','-',' ',true);
							desenhar('Telefone: ' + pacientes[i].pessoa.telefone + ' ','-',' ',true);
							desenhar('-','-','-',false);
							writeln('');
								end;
							count:=count+1;
							end;

					end
				else 
					begin
						if(length(pacientes[i].pessoa.nome)>0) then
							begin
							if(show) then
								begin
							desenhar('-','-','-',false);
							desenhar(' ID: ' + IntToStr(i) + ' ', '-', ' ',false);
							desenhar(' Paciente ' + IntToStr(i) + ' ', '-', ' ',false);
							desenhar('Nome: ' + pacientes[i].pessoa.nome + ' ','-',' ',true);
							desenhar('CPF: ' + pacientes[i].pessoa.cpf + ' ','-',' ',true);
							desenhar('Endereco: ' + pacientes[i].pessoa.endereco + ' ','-',' ',true);
							desenhar('Telefone: ' + pacientes[i].pessoa.telefone + ' ','-',' ',true);
							desenhar('-','-','-',false);
							writeln('');				
								end;			
							count:=count+1;
							end;
					end;
			end;

			writeln('');

		listarPacientes := count;
	end;




	function listarConsultas(consultas:AConsultas; termos:string;show:boolean):integer;
	var 
		i:integer;
		count:integer;
	begin
		count:=0;
		for i:= 1 to 100 do
			Begin
				if(length(termos) > 0) then
					begin
						if((pos(termos,consultas[i].data) > 0) or (pos(termos,consultas[i].paciente.nome) > 0) or (pos(termos,consultas[i].medico.nome) > 0) or (pos(termos,consultas[i].data) > 0))  then
							begin
							if(show) then
								begin
							desenhar('-','-','-',false);
							//desenhar(' ID: ' + IntToStr(i) + ' ', '-', ' ',false);
							desenhar(' Consulta ' + IntToStr(i) + ' ', '-', ' ',false);
							desenhar('Nome: ' + consultas[i].paciente.nome + ' ','-',' ',true);
							desenhar('Medico: ' + consultas[i].medico.nome + ' ','-',' ',true);
							desenhar('Quadro: ' + consultas[i].quadro + ' ','-',' ',true);
							desenhar('Data: ' + consultas[i].data + ' ','-',' ',true);
							desenhar('-','-','-',false);
							writeln('');
								end;
							count:=count+1;
							end;

					end
				else 
					begin
						if(length(consultas[i].data)>0) then
							begin
							if(show) then
								begin
							desenhar('-','-','-',false);
						//desenhar(' ID: ' + IntToStr(i) + ' ', '-', ' ',false);
							desenhar(' Consulta ' + IntToStr(i) + ' ', '-', ' ',false);
							desenhar('Nome: ' + consultas[i].paciente.nome + ' ','-',' ',true);
							desenhar('Medico: ' + consultas[i].medico.nome + ' ','-',' ',true);
							desenhar('Quadro: ' + consultas[i].quadro + ' ','-',' ',true);
							desenhar('Data: ' + consultas[i].data + ' ','-',' ',true);
							desenhar('-','-','-',false);
							writeln('');				
								end;			
							count:=count+1;
							end;
					end;
			end;

			writeln('');

		listarConsultas := count;
	end;




	procedure buscar(pacientes:APacientes; medicos:AMedicos;consultas:AConsultas; onde:string);
		var 
			termos:string;
			i:integer;
			count:integer;
			continua:boolean;
			decisao:char;
		begin
			decisao:=#12;
			continua:= true;


		repeat
			write('Digite os termos de busca: ');
			readln(termos);
			case onde of
				'p': 
					begin
						ClrScr;
						desenhar(' Buscando Pacientes por: ' + termos, '-','-', false);
						count := listarPacientes(pacientes, termos, true);
						if(count = 0) then
							begin
							desenhar('-','-','-', false);
							desenhar(' 0 Pacientes cadastrados ','-',' ', true);
							desenhar('-','-','-', false);
							end;
					end;
				'm': 
					begin
						ClrScr;
						desenhar(' Buscando Medicos por: ' + termos, '-','-', false);
						count := listarMedicos(medicos, termos, true);
						if(count = 0) then
							begin
								desenhar('-','-','-', false);
								desenhar(' 0 Medicos cadastrados ','-',' ', true);
								desenhar('-','-','-', false);
							end;
					end;

			'c': 
					begin
						ClrScr;
						desenhar(' Buscando Consultas por: ' + termos, '-','-', false);
						count := listarConsultas(consultas, termos, true);
						if(count = 0) then
							begin
								desenhar('-','-','-', false);
								desenhar(' 0 Consultas marcadas ','-',' ', true);
								desenhar('-','-','-', false);
							end;
					end;



			end;
			desenhar('-', '-','-', false);
				desenhar('[Enter] Outra Busca', '-',' ', true);
				desenhar(' [ESC]  Finaliza Busca ', '-',' ', true);
				desenhar('-', '-','-', false);
				decisao:= readkey;
				if(decisao = #27) then
					continua := false
					else
					continua := true;
			until(continua = false);
		end;


function selecionaPaciente(var pacientes:APacientes):pessoa;
var
	count:integer;
	decisao:integer;
	i:integer;
	encontrado:boolean;
	p:pessoa;
	dummy:pessoa;
	Begin
	ClrScr;
	encontrado:=false;
		repeat
			count := listarPacientes(pacientes, '', false);
				if(count = 0) then
					begin
								desenhar('-','-','-', false);
								desenhar(' 0 Pacientes cadastrados ','-',' ', true);
								desenhar(' Escolha uma opcao abaixo ','-',' ', true);
								desenhar('-','-','-', false);
								desenhar('-','-','-', false);
								desenhar(' 1) Cadastrar Paciente ','-',' ', true);
								desenhar(' 2) Sair ','-',' ', true);
								desenhar('-','-','-', false);
								readln(decisao);
						if(decisao = 1) then
							begin
								cadastrarPaciente(pacientes);
							end;
					end;
		until ((count > 0) or (decisao = 2));	
		if(decisao <> 2) then
			Begin
				ClrScr;
				repeat
					listarPacientes(pacientes, '', true);
					desenhar('Digite o id do paciente ou', '-', ' ', true);
					desenhar('Digite 0 para SAIR', '-', ' ', true);
					readln(decisao);
					if(decisao > 0) then
						begin
							for i := 1 to 100 do
								begin
									if(pacientes[i].pessoa.id = decisao) then
										begin
											encontrado := true;
											p:= pacientes[i].pessoa;
										end;
									end;
								end;
				until((decisao = 0) or (encontrado));
			end;
			if(decisao = 0) then
		selecionaPaciente := dummy
		else
		selecionaPaciente := p;
	end;

function selecionaMedico(var medicos:AMedicos):pessoa;
var
	count:integer;
	decisao:integer;
	i:integer;
	encontrado:boolean;
	p:pessoa;
	dummy:pessoa;
	Begin
	ClrScr;
	encontrado:=false;
		repeat
			count := listarMedicos(medicos, '', false);
				if(count < 1) then
					begin
						if(count = 0) then
							begin
								desenhar('-','-','-', false);
								desenhar(' 0 Medicos cadastrados ','-',' ', true);
								desenhar(' Escolha uma opcao abaixo ','-',' ', true);
								desenhar('-','-','-', false);
								desenhar('-','-','-', false);
								desenhar(' 1) Cadastrar Medico ','-',' ', true);
								desenhar(' 2) Sair ','-',' ', true);
								desenhar('-','-','-', false);
								readln(decisao);
							end;
						if(decisao = 1) then
							begin
								cadastrarMedico(medicos);
							end;
						end;
		until ((count > 0) or (decisao = 2));	
		if(decisao <> 2) then
			Begin
				ClrScr;
				repeat
					listarMedicos(medicos, '', true);
					desenhar('Digite o id do medico ou', '-', ' ', true);
					desenhar('Digite 0 para SAIR', '-', ' ', true);
					readln(decisao);
					if(decisao > 0) then
						begin
							for i := 1 to 100 do
								begin
									if(medicos[i].pessoa.id = decisao) then
										begin
											encontrado := true;
											p:= medicos[i].pessoa;
										end;
									end;
								end;
				until((decisao = 0) or (encontrado));
			end;
		if(decisao = 0) then
		selecionaMedico := dummy
		else
		selecionaMedico := p;
	end;



procedure cadastrarConsulta(var pessoas:APessoas; var pacientes:APacientes; var medicos:AMedicos; var consultas:AConsultas);
	var
		count:integer;
		decisao:integer;
		i:integer;
		encontrado:boolean;
		p:pessoa;
		m:pessoa;
		quadro:string;
		data:string;
	begin
	p:= selecionaPaciente(pacientes);
	if(length(p.nome) > 0) then
		Begin
			m:= selecionaMedico(medicos);
					if(length(m.nome) > 0) then
						Begin						
							ClrScr;
							write('Digite o quadro/resumo do paciente: ');
							readln(quadro);
							write('Digite a data da consulta: ');
							readln(data);
							desenhar('','-','-', false);

							readkey;

						end;
		end;
end;


	procedure cadastrarTestes(var pacientes:APacientes; var medicos:AMedicos; var consultas:AConsultas);
	var
		i:integer;
		Begin

		for i:= 1 to 5 do
			Begin
				pacientes[i].pessoa.id := i;
				pacientes[i].pessoa.nome := 'Nome_Teste ' + IntToStr(i);
				pacientes[i].pessoa.cpf := 'CPF TESTE ' + IntToStr(i);
				pacientes[i].pessoa.endereco := 'Rua x de y z  ' + IntToStr(i);
				pacientes[i].pessoa.telefone := '(55)11telefone ' + IntToStr(i);

				medicos[i].pessoa.id := i;
				medicos[i].pessoa.nome := 'Nome_Teste ' + IntToStr(i);
				medicos[i].pessoa.cpf := 'CPF TESTE ' + IntToStr(i);
				medicos[i].pessoa.endereco := 'Rua x de y z  ' + IntToStr(i);
				medicos[i].pessoa.telefone := '(55)11telefone ' + IntToStr(i);


				consultas[i].quadro := 'Quadro de Teste ' + IntToStr(i);
				consultas[i].data := '04/09/1990 de teste ' + IntToStr(i);
				consultas[i].medico := medicos[i].pessoa;
				consultas[i].paciente := medicos[i].pessoa;




			end;

		end;

////////////////////////////MOSTRAR MENU

procedure mostrarMenu(var pessoas:APessoas; var pacientes:APacientes; var medicos:AMedicos; var consultas:AConsultas);
	var 
		menu_validado:boolean;
		menu_temp:char;
		menu:integer;
		count:integer;

	begin
		menu_validado := false;
		count:=0;
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
	desenhar('9) Cadastrar Testes', '|',' ', true);
	desenhar('','|',' ', false);	
	desenhar('','-','-', false);
	desenhar('0) Fechar Programa', '|',' ', true);
	desenhar('','-','-', false);
	write('Digite uma opção: ');
	// readln(menu_temp);
	menu_temp := readkey;
	menu_validado := validaMenu(menu_temp);
	repeat
	if(menu_validado = false) then
		begin
			writeln('');
			write('Deve ser digitado um menu entre 0 e 9: ');
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
			ClrScr;
			buscar(pacientes, medicos, consultas, 'p');
				// desenhar('-','-','-', false);
				// desenhar(' Pressione enter para voltar ','-',' ', true);
				// desenhar('-','-','-', false);
				// readkey;			
			End;

		'4' : Begin
			//Buscar Medico
			ClrScr;
			buscar(pacientes, medicos, consultas, 'm');
				// desenhar('-','-','-', false);
				// desenhar(' Pressione enter para voltar ','-',' ', true);
				// desenhar('-','-','-', false);
				// readkey;
			End;						


		'5' : Begin
			//Marcar Consulta
			cadastrarConsulta(pessoas,pacientes,medicos,consultas);

			End;


		'6' : Begin
			//Consultas Marcadas
			buscar(pacientes, medicos, consultas, 'c');
			End;


			
		'7' : Begin
			//Listar Pacientes
			ClrScr;
			count:= listarPacientes(pacientes, '', true);
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
			End;


		'8' : Begin
			ClrScr;
			listarMedicos(medicos, '', true);
				desenhar('-','-','-', false);
				desenhar(' Pressione enter para voltar ','-',' ', true);
				desenhar('-','-','-', false);
				readkey;
			End;

		'9' : Begin
			//Cadastrar Testes
			ClrScr;
			cadastrarTestes(pacientes, medicos, consultas);
			writeln('5 Médicos, 5 Pacientes e 5 Consultas de teste Cadastrados');
			writeln('Pressione qualquer teclada para RETORNAR');
			readkey;
			End;
	End; {CASE}

	


	until menu_temp = '0';

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
Loading_screen(2,2,0);
mostrarMenu(pessoas, pacientes, medicos, consultas);
writeln('');
END.
