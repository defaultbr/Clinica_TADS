Program Pzim ;

type
	type_medico = record
	nome:string;
	cpf:string;
	crm:string;
	telefone:string;
	endereco:string;
	salario:real;
	position:integer;
end;

	type_paciente = record
	nome:string;
	cpf:string;
	convenio:string;
	observacoes:string;
	telefone:string;
	endereco:string ;
		position:integer;
end;

	type_consulta = record
	data:string;
	valor:real;
	medico:type_medico;
	paciente:type_paciente;
	position:integer;
end;

db_medicos = file of type_medico;
db_pacientes = file of type_paciente;
db_consultas = file of type_consulta;


//Variaveis globais, colocar todos os métodos abaixo
var
	medicos:db_medicos;
	pacientes:db_pacientes;
	consultas:db_consultas;
	menu:integer;
	sub_menu:integer;
	draw:string;
	medico:type_medico;
	paciente:type_paciente;
	



{
 	Criar Arquivos de Database caso não existam
}

procedure createDatabases(var m:db_medicos; var p:db_pacientes; var c:db_consultas);
begin
//Criar DB Medicos
		reset(m);
		if ioresult <> 0 then
		rewrite(m);
		close(m);		
//Criar DB Pacientes		
		reset(p);
		if ioresult <> 0 then
		rewrite(p);
		close(p);		
//Criar DB Consultas		
		reset(c);
		if ioresult <> 0 then
		rewrite(c);
		close(c);
end;



{ 
	Função para o submenu de escolhas Cadastrar/Consultar/Alterar e Deletar
}

function s_menu(titulo:string):integer;
var
	option:integer;
begin
	clrscr;
	writeln(draw,' ',titulo,' ',draw);
	writeln('1 - Médico');
	writeln('2 - Paciente');
	writeln('3 - Consulta');
	writeln('');
	writeln('0 - Voltar para tela principal');
	writeln('');
	write('Escolha uma opção: ');
	readln(option);
	s_menu := option;
end;







//---------------===============================----------------=========================-----------------------------------
{ 
 Menu de cadastro de paciente
}
function cadastrarPaciente():type_paciente;
var
	paciente:type_paciente;
begin

	write('Nome: '); readln(paciente.nome);
	write('CPF: '); readln(paciente.cpf);
	write('Convênio: '); readln(paciente.convenio);
	write('Telefone: '); readln(paciente.telefone);
	write('Endereço: '); readln(paciente.endereco);                                               
	write('Observações: '); readln(paciente.observacoes);	
	cadastrarPaciente:=paciente;
end;

function selecionarPaciente(var db:db_pacientes):type_paciente;
var
	paciente:type_paciente;
	paciente_aux:type_paciente;
	termos:string;
	count:integer;
	position:integer;
	choice:char;
begin
	clrscr;
	position:=0;
	count:=0;
	paciente_aux.nome := 'NULL';
	writeln(draw,' Digite os termos para localizar o paciênte (nome/cpf) e  pressione enter',draw);
	writeln('');
	write('Termos: ');              	
	readln(termos);
	            
	reset(db);
	while not eof(db) do
	begin
		read(db,paciente);
		if((pos(termos,paciente.nome)>0)		or (pos(termos,paciente.cpf)>0)) then
			count:=count+1;
	end;		
	close(db);	
	if(count >0) then    
	begin
	reset(db);
	while not eof(db) do
	begin
		clrscr;
		read(db,paciente);	
		if((pos(termos,paciente.nome)>0)		or (pos(termos,paciente.cpf)>0)) then		
		begin
		position:=position+1;
		writeln('--> Paciente localizado [',position,'/',count,']');
		write('Nome: '); writeln(paciente.nome);
		write('CPF: '); writeln(paciente.cpf);
		write('Convênio: '); writeln(paciente.convenio);
		write('Telefone: '); writeln(paciente.telefone);
		write('Endereço: '); writeln(paciente.endereco);
		write('Observações: '); writeln(paciente.observacoes);
		writeln('');
		writeln('Aperte ENTER para confirmar ou ESPAÇO para o próximo: ');
		choice:= readkey;
		if(choice = #13) then
			begin  
			paciente.position:= FILEPOS(db);
			paciente_aux:=paciente;
			break;
			end;
		end;
	end;	        
	close(db);
	end
	ELSE
	begin
	writeln('Não foi encontrado nenhum resultado por estes termos');
	writeln('Pressione qualquer tecla para retornar ao menu principal');
	readkey;
	end;
	selecionarPaciente:=paciente_aux;
end;


procedure listarMedicos(var db:db_medicos);
var
	medico:type_medico;
begin
	clrscr;
	reset(db);
	while not eof(db) do
	begin
		read(db,medico);		
		write('----');
		write('Nome: '); writeln(medico.nome);
		write('CPF: '); writeln(medico.cpf);
		write('CRM: '); writeln(medico.crm);
		write('Telefone: '); writeln(medico.telefone);
		write('Endereço: '); writeln(medico.endereco);
		write('Salário: '); writeln(medico.salario);
		writeln('');
	end;	        
	close(db);
	writeln('Pressione qualquer tecla para retornar ao menu principal');
	readkey;
end;






//---------------===============================----------------=========================-----------------------------------

{ 
 Menu de cadastro de médico
}

procedure cadastrarMedico(var db:db_medicos);
var
	medico:type_medico;
begin
	write('Nome: '); readln(medico.nome);
	write('CPF: '); readln(medico.cpf);
	write('CRM: '); readln(medico.crm);
	write('Telefone: '); readln(medico.telefone);
	write('Endereço: '); readln(medico.endereco);
	write('Salário: '); readln(medico.salario);	
	append(db);
	write(db,medico);	
	close(db);	
	writeln('');
	writeln('Médico cadastrado com sucesso, aperte qualquer tecla para retornar');
	readkey;
end;

function selecionarMedico(var db:db_medicos):type_medico;
var
	medico:type_medico;
	medico_aux:type_medico;
	termos:string;
	count:integer;
	position:integer;
	choice:char;
begin
	clrscr;
	position:=0;
	count:=0;
	medico_aux.nome := 'NULL';
	writeln(draw,' Digite os termos para localizar o médico (nome/cpf ou crm) e  pressione enter',draw);
	writeln('');
	write('Termos: ');              	
	readln(termos);
	            
	reset(db);
	while not eof(db) do
	begin
		read(db,medico);
		if((pos(termos,medico.nome)>0)		or (pos(termos,medico.cpf)>0)		or (pos(termos,medico.crm)>0)) then
			count:=count+1;
	end;		
	close(db);	
	if(count >0) then    
	begin
	reset(db);
	while not eof(db) do
	begin
		clrscr;
		read(db,medico);	
		if((pos(termos,medico.nome)>0)		or (pos(termos,medico.cpf)>0)		or (pos(termos,medico.crm)>0)) then		
		begin
		position:=position+1;
		writeln('--> Médico localizado [',position,'/',count,']');
		write('Nome: '); writeln(medico.nome);
		write('CPF: '); writeln(medico.cpf);
		write('CRM: '); writeln(medico.crm);
		write('Telefone: '); writeln(medico.telefone);
		write('Endereço: '); writeln(medico.endereco);
		write('Salário: '); writeln(medico.salario);
		writeln('');
		writeln('Aperte ENTER para confirmar ou ESPAÇO para o próximo: ');
		choice:= readkey;
		if(choice = #13) then
			begin  
			medico.position:= FILEPOS(db);
			medico_aux:=medico;
			break;
			end;
		end;
	end;	        
	close(db);
	end
	ELSE
	begin
	writeln('Não foi encontrado nenhum resultado por estes termos');
	writeln('Pressione qualquer tecla para retornar ao menu principal');
	readkey;
	end;
	selecionarMedico:=medico_aux;
end;

procedure alterarMedico(var db:db_medicos);
var
	choice:char;
begin
		medico:=selecionarMedico(medicos);
		clrscr;
		if(medico.nome <> 'NULL') then
		begin		
		writeln('--> Dados Atuais');
		write('Nome: '); writeln(medico.nome);
		write('CPF: '); writeln(medico.cpf);
		write('CRM: '); writeln(medico.crm);
		write('Telefone: '); writeln(medico.telefone);
		write('Endereço: '); writeln(medico.endereco);
		write('Salário: '); writeln(medico.salario);
		writeln('');
		writeln('--> Novos Dados');
		write('Nome: '); readln(medico.nome);
		write('CPF: '); readln(medico.cpf);
		write('CRM: '); readln(medico.crm);
		write('Telefone: '); readln(medico.telefone);
		write('Endereço: '); readln(medico.endereco);
		write('Salário: '); readln(medico.salario);		
		writeln('Aperte ENTER para CONFIRMAR ou ESC para cancelar ');		
		choice:= readkey;
		if(choice = #13) then  
		begin
		reset(db);
		seek(db, medico.position-1);	
		write(db,medico);
		close(db);
		end;	
		end;		
end;


procedure listarPacientes(var db:db_pacientes);
var
	paciente:type_paciente;
begin
	clrscr;
	reset(db);
	while not eof(db) do
	begin
		read(db,paciente);		
		write('----');
		write('Nome: '); writeln(paciente.nome);
		write('CPF: '); writeln(paciente.cpf);
		write('Convênio: '); writeln(paciente.convenio);
		write('Telefone: '); writeln(paciente.telefone);
		write('Endereço: '); writeln(paciente.endereco);
		write('Observações: '); writeln(paciente.observacoes);
		writeln('');
	end;	        
	close(db);
	writeln('Pressione qualquer tecla para retornar ao menu principal');
	readkey;
end;



procedure alterarPaciente(var db:db_pacientes);
var
	choice:char;
begin

		paciente:=selecionarPaciente(db);
		clrscr;
		writeln('--> Dados Atuais');
		write('Nome: '); writeln(paciente.nome);
		write('CPF: '); writeln(paciente.cpf);
		write('Convênio: '); writeln(paciente.convenio);
		write('Telefone: '); writeln(paciente.telefone);
		write('Endereço: '); writeln(paciente.endereco);
		write('Observações: '); writeln(paciente.observacoes);
		writeln('');
		writeln('--> Novos Dados');
		write('Nome: '); readln(paciente.nome);
		write('CPF: '); readln(paciente.cpf);
		write('Convênio: '); readln(paciente.convenio);
		write('Telefone: '); readln(paciente.telefone);
		write('Endereço: '); readln(paciente.endereco);
		write('Observações: '); readln(paciente.observacoes);
		writeln('Aperte ENTER para CONFIRMAR ou ESC para cancelar ');		
		choice:= readkey;
		if(choice = #13) then  
		begin
		reset(db);
		seek(db, paciente.position-1);	
		write(db,paciente);
		close(db);	
		end;
				
end;

//---------------===============================----------------=========================-----------------------------------
{ 
 Menu de Consultas
}

function cadastrarConsulta(var medicos:db_medicos;var pacientes:db_pacientes;var db:db_consultas):type_consulta;
var
	consulta:type_consulta;
	paciente:type_paciente;
	medico:type_medico;
	data:string;
	valor:real;	
	choice:char;
begin
clrscr;
	writeln(draw,' Agendamento de consultas ',draw);
	writeln('Primeiro você deve selecionar um paciente, pressione ENTER para pesquisar');
	readkey;
	paciente := selecionarPaciente(pacientes);
	if(paciente.nome <> 'NULL') then
	begin 
		clrscr;	
		writeln('Agora você deve selecionar um médico responsável');
		readkey;
		medico:=selecionarMedico(medicos);
			if(medico.nome <> 'NULL') then
			begin
				clrscr;
				write('Digite a data da consulta: ');
				readln(data);
				write('Digite o valor da consulta: ');
				readln(valor);
				consulta.data := data;
				consulta.valor := valor;
				consulta.medico := medico;
				consulta.paciente := paciente;
				clrscr;
				writeln('---------------------------------------');
				writeln('Agendamento de Consulta');
				writeln('---------------------------------------');
				writeln('Paciente: ',paciente.nome);
				writeln('Médico: ', medico.nome);
				writeln('Data: ', data);
				writeln('Valor: ', valor:2:2);
				writeln('---------------------------------------');
				writeln('');
				writeln('Pressione ENTER para confirmar o agendamento ou ESC para cancelar');
				choice:= readkey;
				if(choice = #13) then  
				begin
				append(db);	
				write(db,consulta);
				close(db);	
				end;							
			end
			ELSE
			begin
				writeln('Nenhum médico selecionado, pressione qualquer tecla para retornar à tela principal');			
			end;
	end
	ELSE
	begin
	writeln('Nenhum paciente selecionado, pressione qualquer tecla para retornar à tela principal');
	readkey;
	end;	
	cadastrarConsulta:=consulta;
end;

procedure listarConsultas(var db:db_consultas);
var
	consulta:type_consulta;
begin
	clrscr;
	reset(db);
	while not eof(db) do
	begin
		read(db,consulta);		
		writeln('--> Consulta localizada');
		write('Paciente: '); writeln(consulta.paciente.nome);
		write('Médico: '); writeln(consulta.medico.nome);
		write('Data: '); writeln(consulta.data);
		write('Valor: '); writeln(consulta.valor:2:2);
		writeln('');
	end;	        
	close(db);
	writeln('Pressione qualquer tecla para retornar ao menu principal');
	readkey;
end;


function selecionarConsulta(var db:db_consultas):type_consulta;
var
	consulta:type_consulta;
	consulta_aux:type_consulta;
	termos:string;
	count:integer;
	position:integer;
	choice:char;
begin
	clrscr;
	position:=0;
	count:=0;
	writeln(draw,' Digite os termos para localizar a consulta nome,cpf, crm do médico ou paciente ou a data e pressione enter',draw);
	writeln('');
	write('Termos: ');              	
	readln(termos);
	
	reset(db);
	while not eof(db) do
	begin
		read(db,consulta);
		if((
		
		pos(termos,consulta.paciente.nome)>0)
		or (pos(termos,consulta.medico.nome)>0)				
		or (pos(termos,consulta.medico.cpf)>0)		
		or (pos(termos,consulta.paciente.cpf)>0)
		or (pos(termos,consulta.medico.cpf)>0)		
		or (pos(termos,consulta.medico.crm)>0)		
		or (pos(termos,consulta.data)>0)			
		
		) then
			count:=count+1;
	end;		
	close(db);	
	if(count >0) then    
	begin
	reset(db);
	while not eof(db) do
	begin
		clrscr;
		read(db,consulta);	
		if((
		
		pos(termos,consulta.paciente.nome)>0)
		or (pos(termos,consulta.medico.nome)>0)				
		or (pos(termos,consulta.medico.cpf)>0)		
		or (pos(termos,consulta.paciente.cpf)>0)
		or (pos(termos,consulta.medico.cpf)>0)		
		or (pos(termos,consulta.medico.crm)>0)		
		or (pos(termos,consulta.data)>0)				
		) then		
		begin
		position:=position+1;
		writeln('--> Consulta');
		write('Paciente: '); writeln(consulta.paciente.nome);
		write('Médico: '); writeln(consulta.medico.nome);
		write('Data: '); writeln(consulta.data);
		write('Valor: '); writeln(consulta.valor:2:2);
		writeln('');
		writeln('Aperte ENTER para confirmar ou espaço para o próximo: ');
		choice:= readkey;
		if(choice = #13) then
			begin  
			consulta.position:= FILEPOS(db);
			consulta_aux:=consulta;
			break;
			end;
		end;
	end;	        
	close(db);
	end
	ELSE
	writeln('Não foi encontrado nenhum resultado por estes termos');
	writeln('Pressione qualquer tecla para retornar ao menu principal');
	readkey;
	selecionarConsulta:=consulta_aux;
end;



procedure alterarConsulta(var db:db_consultas;var medicos:db_medicos;var pacientes:db_pacientes);
var
	choice:char;
	consulta:type_consulta;
	temp_position:integer;
begin

		consulta:=selecionarConsulta(db);
		if(consulta.paciente.nome <> 'NULL') then
		begin
		clrscr;
		writeln('--> Dados Atuais');
		write('Paciente: '); writeln(consulta.paciente.nome);
		write('Médico: '); writeln(consulta.medico.nome);
		write('Data: '); writeln(consulta.data);
		write('Valor: '); writeln(consulta.valor:2:2);
		temp_position:= consulta.position;
		writeln('');
		writeln('--> Novos Dados');
		consulta:=cadastrarConsulta(medicos,pacientes,consultas);
		consulta.position:=temp_position;
		writeln('Aperte ENTER para CONFIRMAR ou ESC para cancelar ');		
		choice:= readkey;
		if(choice = #13) then  
		begin
		reset(db);
		seek(db, consulta.position-1);	
		write(db,consulta);
		close(db);	
		end;
		end;
				
end;


//---------------===============================----------------=========================-----------------------------------
	
	

Begin	
	draw:='/\/\/\//\/\/\/\';
	sub_menu:=999;
	assign(medicos,'Medicos.dat');
	assign(pacientes,'Pacientes.dat');
	assign(consultas,'Consultas.dat');		
	createDatabases(medicos,pacientes,consultas);	
	
	repeat
	clrscr;
	writeln('1 - Cadastrar');
	writeln('3 - Pesquisar');
	writeln('5 - Listar');
	writeln('7 - Alterar');
	writeln('');
	writeln('0 - Sair do Sistema');
	writeln('');
	write('Escolha uma opção: ');
	readln(menu);	
	
	case menu of
	    1: 
	    	BEGIN             
	    	//Case do submenu para cadastro
	    	   sub_menu := s_menu('Cadastrar');
	    	   case sub_menu of
	    	   	1: 
	    	   	BEGIN
							clrscr;
							writeln(draw,' Digite os dados do médico ',draw);	    	   	
		    	   	cadastrarMedico(medicos);
	    	   	END;
	    	   	2: 
	    	   	BEGIN
	    	   		clrscr;
							writeln(draw,' Digite os dados do paciente ',draw);
	    	   		paciente:= cadastrarPaciente();	
							append(pacientes);
							write(pacientes,paciente);	
							close(pacientes);	
							writeln('');
							writeln('Paciente cadastrado com sucesso, aperte qualquer tecla para retornar');
							readkey;							     	   	
	    	   	END;
	    	   	3: 
	    	   	BEGIN
	    	   		cadastrarConsulta(medicos,pacientes,consultas);
	    	   	END;	    	   	
	    	   end;
	    	END;
	    3: 
	    	BEGIN  
	    	   sub_menu := s_menu('Pesquisar');
	    	   case sub_menu of
	    	   	1: 
	    	   	BEGIN
	    	   	selecionarMedico(medicos);
	    	   	END;
	    	   	2: 
	    	   	BEGIN
	    	   	selecionarPaciente(pacientes);	    	   	
	    	   	END;
	    	   	3: 
	    	   	BEGIN
	    	   	selecionarConsulta(consultas);
	    	   	END;
					END;	    	   		    	   
	    	END;
	    	
	    5: 
	    	BEGIN
	    	   sub_menu := s_menu('Listar');					 	    	
	    	    case sub_menu of
	    	   	1: 
	    	   	BEGIN
	    	   	listarMedicos(medicos);
	    	   	END;
	    	   	2: 
	    	   	BEGIN
	    	   	listarPacientes(pacientes);  	   	
	    	   	END;
	    	   	3: 
	    	   	BEGIN
	    	   	listarConsultas(consultas);
	    	   	END;
					END;	    	   		
	    	END;
	    7: 
	    	BEGIN
	    	   sub_menu := s_menu('Alterar');
					 case sub_menu of
	    	   	1: 
	    	   	BEGIN
		    	   	alterarMedico(medicos);
	    	   	END;
	    	   	2: 
	    	   	BEGIN
		    	   	alterarPaciente(pacientes);						    	   	
	    	   	END;
	    	   	3: 
	    	   	BEGIN
	    	   		alterarConsulta(consultas,medicos,pacientes);
	    	   	END;
					END;	    	   			    	   
	    	END;								    	
	end;	
	until(menu = 0);			
End.