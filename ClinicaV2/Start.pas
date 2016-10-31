Program Pzim ;


type
	type_medico = record
	nome:string;
	cpf:string;
	crm:string;
	telefone:string;
	endereco:string;
	salario:real;
end;

	type_paciente = record
	nome:string;
	cpf:string;
	observacoes:string;
	telefone:string;
	endereco:string
end;

	type_consulta = record
	data:string;
	valor:real;
	medico:type_medico;
	paciente:type_paciente;
end;

db_medicos = file of type_medico;
db_pacientes = file of type_paciente;
db_consultas = file of type_consulta;


//Variaveis globais, colocar todos os métodos acima
var
	medicos:db_medicos;
	pacientes:db_pacientes;
	consultas:db_consultas;
	menu:integer;
	sub_menu:integer;
	draw:string;




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


{ 
 Menu de cadastro de médico
}

procedure cadastrarMedico(var m:db_medicos);
var
	medico:type_medico;
begin
	clrscr;
	writeln(draw,' Digite os dados do médico ',draw);
	write('Nome: '); readln(medico.nome);
	write('CPF: '); readln(medico.cpf);
	write('CRM: '); readln(medico.crm);
	write('Telefone: '); readln(medico.telefone);
	write('Endereço: '); readln(medico.endereco);
	write('Salário: '); readln(medico.salario);
	
	append(m);
	write(m,medico);	
	close(m);	
	writeln('');
	writeln('Médico cadastrado com sucesso, aperte qualquer tecla para retornar');
	readkey;

end;

procedure cadastrarPaciente(var p:db_pacientes);
var
	paciente:type_paciente;
begin
	clrscr;
	writeln(draw,' Digite os dados do Paciente ',draw);
	write('Nome: '); readln(paciente.nome);
	write('CPF: '); readln(paciente.cpf);
	write('Telefone: '); readln(paciente.telefone);
	write('Endereço: '); readln(paciente.endereco);
	write('Observações: '); readln(paciente.observacoes);
	
	append(p);
	write(p,paciente);	
	close(p);	
	writeln('');
	writeln('Paciente cadastrado com sucesso, aperte qualquer tecla para retornar');
	readkey;
end;



function pesquisarMedico(var db:db_medicos):type_medico;
var
	medico:type_medico;
	termos:string;
	count:integer;
	position:integer;
begin
	clrscr;
	position:=0;
	count:=0;
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
		writeln('Aperte ESPAÇO para o próximo: ');
		readkey;
		end;
	end;	        
	close(db);
	end
	ELSE
	writeln('Não foi encontrado nenhum resultado por estes termos');
	writeln('Pressione qualquer tecla para retornar ao menu principal');
	readkey;
	pesquisarMedico:=medico;
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
		writeln('Aperte ENTER para selecionar ou ESPAÇO para o próximo: ');
		choice:= readkey;
		if(choice = #13) then
			medico_aux:=medico;
			break;
		end;
	end;	        
	close(db);
	end
	ELSE
	writeln('Não foi encontrado nenhum resultado por estes termos');
	writeln('Pressione qualquer tecla para retornar ao menu principal');
	readkey;
	selecionarMedico:=medico_aux;
end;



	
	

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
	writeln('5 - Alterar');
	writeln('7 - Deletar');
	writeln('9 - Cancelar Consulta');
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
	    	   		cadastrarMedico(medicos);
	    	   	END;
	    	   	2: 
	    	   	BEGIN
	    	   		cadastrarPaciente(pacientes);	    	   	
	    	   	END;
	    	   	3: 
	    	   	BEGIN
	    	   	END;	    	   	
	    	   end;
	    	END;
	    3: 
	    	BEGIN  
	    	   sub_menu := s_menu('Pesquisar');
	    	   case sub_menu of
	    	   	1: 
	    	   	BEGIN
	    	   	pesquisarMedico(medicos);
	    	   		//selecionarMedico(medicos);
	    	   	END;
	    	   	2: 
	    	   	BEGIN
	    	   	//	cadastrarPaciente(pacientes);	    	   	
	    	   	END;
	    	   	3: 
	    	   	BEGIN
	    	   	
	    	   	END;
					END;	    	   		    	   
	    	END;
	    5: 
	    	BEGIN
	    	   sub_menu := s_menu('Alterar');
	    	END;								    	
	end;
		
	until(menu = 0);	
	
	
	
	
	
	
	
	
	
	
End.