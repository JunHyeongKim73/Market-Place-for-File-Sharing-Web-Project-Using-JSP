CREATE TABLE user
	(user_ID varchar(5),
	 name varchar(10) not null,
	 address varchar(20),
	 acc_no varchar(255) not null,
	 phone_no varchar(255) not null,
	 birthday datetime not null,
	 date_joined datetime not null,
	 ID varchar(10) not null,
	 PW varchar(255) not null,
	 viewer int(2) not null,
	 audio int(2) not null,
	 download_no int(10) not null check (download_no >= 0),
	 amount_due int(10) not null check (amount_due >= 0),
	 primary key (user_ID)
	);

CREATE TABLE provider
	(provider_ID varchar(5),
	 name varchar(10) not null,
	 address varchar(20),
	 acc_no varchar(255) not null,
	 join_fee int(10) not null check (join_fee >= 0),
	 amount_due int(10) not null check (amount_due >= 0),
	 amount_left int(10) not null check (amount_left >= 0),
	 date_joined datetime not null,
	 ID varchar(10) not null,
	 PW varchar(255) not null,
	 primary key (provider_ID)
	);

CREATE TABLE item
	(item_ID varchar(5),
	 provider_ID varchar(5) not null,
	 name varchar(10) not null,
	 type varchar(255) not null,
	 size int(10) not null check (size >= 0),
	 language varchar(20),
	 price int(10) not null check (price >= 0),
	 download_no int(10) not null check (download_no >= 0),
	 version varchar(255) not null,
	 description varchar(255) not null,
	 last_update datetime not null,
	 primary key (item_ID),
	 foreign key (provider_ID) references provider(provider_ID)
	 	on delete cascade
	);
	 
CREATE TABLE income
	(profit int(10) not null check (profit >= 0),
	 loss int(10) not null check (loss >= 0)
	);

CREATE TABLE admin
	(Admin_ID varchar(10),
	 Admin_PW varchar(255) not null,
	 primary key (Admin_ID)
	);

CREATE TABLE subscribe
	(user_ID varchar(5),
	 subscription_fee int(10) not null check (subscription_fee >= 0),
	 subscription_date datetime not null,
	 primary key (user_ID),
	 foreign key (user_ID) references user(user_ID)
	 	on delete cascade
	);

CREATE TABLE userbill
	(user_ID varchar(5),
	 charge_date datetime not null,
	 amount_charge int(10) not null check (amount_charge >= 0),
	 primary key (user_ID),
	 foreign key (user_ID) references user(user_ID)
	 	on delete cascade
	);

CREATE TABLE providerbill
	(provider_ID varchar(5),
	 charge_date datetime not null,
	 amount_charge int(10) not null check (amount_charge >= 0),
	 primary key (provider_ID),
	 foreign key (provider_ID) references provider(provider_ID)
	  	on delete cascade
	);

CREATE TABLE providerpayment
	(provider_ID varchar(5),
	 send_date datetime not null,
	 amount_send int(10) not null check (amount_send >= 0),
	 primary key (provider_ID),
	 foreign key (provider_ID) references provider(provider_ID)
	  	on delete cascade
	);

CREATE TABLE item_detail
	(item_ID varchar(5),
	 item_keyword varchar(255) not null,
	 machine_required varchar(20),
	 os_required varchar(20),
	 viewer_need varchar(20),
	 primary key (item_ID),
	 foreign key (item_ID) references item(item_ID)
		on delete cascade
	);

CREATE TABLE dropped_item
	(item_ID varchar(5),
	 dropped_date datetime not null,
	 dropped_reason varchar(20),
	 primary key (item_ID)
	);

CREATE TABLE download
	(user_ID varchar(5),
	 item_ID varchar(5),
	 download_time datetime not null,
	 primary key (user_ID, item_ID),
	 foreign key (user_ID) references user(user_ID)
	);

CREATE TABLE storage
	(item_ID varchar(5),
	 provider_ID varchar(5),
	 item_address varchar(255) not null,
	 disk_space int(10) not null,
	 cost int(10) not null check (cost >= 0),
	 primary key (item_ID, provider_ID),
	 foreign key (item_ID) references item(item_ID)
		on delete cascade,
	 foreign key (provider_ID) references provider(provider_ID)
	  	on delete cascade
	);

CREATE TABLE numtable
	(userNum int(10) not null check (userNum >= 0),
	 providerNum int(10) not null check (providerNum >= 0),
	 itemNum int(10) not null check (itemNum >= 0)
	);
