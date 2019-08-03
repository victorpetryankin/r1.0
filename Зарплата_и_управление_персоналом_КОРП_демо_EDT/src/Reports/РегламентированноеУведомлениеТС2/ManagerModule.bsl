#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеТС2.Форма.Форма2015_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2015_1";
	Стр.ОписаниеФормы = "ТС-2/приказ ФНС России от 22.06.2015 № ММВ-7-14/249@";
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Возврат ПечатьСразу_Форма2015_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Возврат СформироватьМакет_Форма2015_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2015_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2015_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция СформироватьМакет_Форма2015_1(Объект)
	ПечатнаяФорма = Новый ТабличныйДокумент;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УведомлениеОСпецрежимах_"+Объект.ВидУведомления.Метаданные().Имя;
	
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_MXL_Форма2015_1");
	ОбластьТитульный = МакетУведомления.ПолучитьОбласть("Титульный");
	ПараметрыМакета = ОбластьТитульный.Параметры;
	СтруктураПараметров = Объект.ДанныеУведомления.Получить();
	Титульный = СтруктураПараметров.Титульный[0];
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.П_ИНН, "ИНН_", ПараметрыМакета, 12, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.П_КПП, "КПП_", ПараметрыМакета, 9, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.КОД_НО, "КОД_НО_", ПараметрыМакета, 4, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.НАИМЕНОВАНИЕ_ОРГАНИЗАЦИИ, "ОрганизацияНазвание_", ПараметрыМакета, 160, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ОГРН, "ОГРН_", ПараметрыМакета, 13, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ОГРНИП, "ОГРНИП_", ПараметрыМакета, 15, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Титульный.ДАТА_ПР, "ДатаПрекрДеят_", ПараметрыМакета, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(Титульный.ПРИЛОЖЕНО_ЛИСТОВ, "ПриложеноЛистов_", ПараметрыМакета, 3, Истина, "-");
	
	ПараметрыМакета.ПризнакПодписанта = Титульный.ПРИЗНАК_НП_ПОДВАЛ;
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантФамилия, "ОргПодписантФамилия_", ПараметрыМакета, 20, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантИмя, "ОргПодписантИмя_", ПараметрыМакета, 20, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантОтчество, "ОргПодписантОтчество_", ПараметрыМакета, 20, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ИНН_ПОДПИСАНТА, "ИНН_ПОДПИСАНТ_", ПараметрыМакета, 12, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ТЕЛЕФОН, "Телефон_", ПараметрыМакета, 20, "-");
	ПараметрыМакета.Email = Титульный.EMAIL_ПОДПИСАНТА;
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ТЕЛЕФОН, "Телефон_", ПараметрыМакета, 20, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ, "ДокументПредставителя_", ПараметрыМакета, 40, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Титульный.ДАТА_ПОДПИСИ, "ДатаПодписи_", ПараметрыМакета, "-");
	
	ПечатнаяФорма.Вывести(ОбластьТитульный);
	Возврат ПечатнаяФорма;
КонецФункции

Функция ПечатьСразу_Форма2015_1(Объект)
	
	ПечатнаяФорма = СформироватьМакет_Форма2015_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
	
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2015_1(СведенияОтправки)
	Префикс = "UT_UVTORGSBSN";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Процедура Проверить_Форма2015_1(Данные, УникальныйИдентификатор)
	Если Не ЗначениеЗаполнено(Данные.Титульный[0].ДАТА_ПР) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указана дата прекращения предпринимательской деятельности", УникальныйИдентификатор);
		ВызватьИсключение "";
	КонецЕсли;
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2015_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация));
	Если ОсновныеСведения.ЭтоПБОЮЛ Тогда
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПФЛ(Объект, ОсновныеСведения);
	Иначе 
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	КонецЕсли;
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьОбщиеДанные(Объект, ОсновныеСведения);
	Данные = Объект.ДанныеУведомления.Получить();
	Проверить_Форма2015_1(Данные, УникальныйИдентификатор);
	Титульный = Данные.Титульный[0];
	
	ОсновныеСведения.Вставить("ИННПодп", Титульный.ИНН_ПОДПИСАНТА);
	ОсновныеСведения.Вставить("EmailПодп", Титульный.EMAIL_ПОДПИСАНТА);
	ОсновныеСведения.Вставить("Тлф", Титульный.ТЕЛЕФОН);
	ОсновныеСведения.Вставить("ДатаПр", Титульный.ДАТА_ПР);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2015_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	ОсновныеСведения.Вставить("НаимОргПредст", Титульный.ОРГ_ПРЕДСТАВИТЕЛЬ);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2015_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2015_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2015_1");
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметры(ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(СтруктураВыгрузки);
	
	Текст = Документы.УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Функция СоздатьНовыйТС2()
	ДокОбъект = Документы.УведомлениеОСпецрежимахНалогообложения.СоздатьДокумент();
	ДокОбъект.ИмяФормы = "Форма2015_1";
	ДокОбъект.ИмяОтчета = "РегламентированноеУведомлениеТС2";
	ДокОбъект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС2;
	Возврат ДокОбъект;
КонецФункции

Процедура ЗаполнитьДаннымиТС2(ДокОбъект, Выборка)
	ПоказателиОтчета = Выборка.ДанныеОтчета.Получить().ПоказателиОтчета.ПолеТабличногоДокументаТитульный;
	
	ДокОбъект.Организация = Выборка.Организация;
	ДокОбъект.ДатаПодписи = Выборка.ДатаПодписи;
	ДокОбъект.Дата = Выборка.Дата;
	
	СтрокаСум = "";
	Для Инд = 1 По 4 Цикл 
		СтрокаСум = СтрокаСум + ПоказателиОтчета["НалоговыйОрган" + Инд];
	КонецЦикла;
	ДокОбъект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Выборка.Организация, , СтрокаСум);
	
	Попытка
		Подписант = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПоказателиОтчета.ОргПодписант, " ");
		ДокОбъект.ПодписантФамилия = Подписант[0];
		ДокОбъект.ПодписантИмя = Подписант[1];
		ДокОбъект.ПодписантОтчество = Подписант[2];
	Исключение
		Ошибка = ИнформацияОбОшибке();
		СтрОш = НСтр("ru = 'Не удалось получить ФИО подписанта'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(СтрОш, УровеньЖурналаРегистрации.Предупреждение,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
		
	ДокОбъект.ПодписантТелефон = ПоказателиОтчета.ТелефонПодписанта;
	ДокОбъект.ПодписантПризнак = ПоказателиОтчета.ПрПодп;
	
	СтруктураПараметров = Новый Структура("Титульный");
	СтруктураПараметров.Вставить("КОД_НО", СтрЗаменить(СтрокаСум, "-", ""));
	СтрокаСум = "";
	Для Инд = 1 По 12 Цикл 
		СтрокаСум = СтрокаСум + ПоказателиОтчета["ИНН1_" + Инд];
	КонецЦикла;
	СтруктураПараметров.Вставить("П_ИНН", СтрЗаменить(СтрокаСум, "-", ""));
	СтрокаСум = "";
	Для Инд = 1 По 9 Цикл 
		СтрокаСум = СтрокаСум + ПоказателиОтчета["КПП1_" + Инд];
	КонецЦикла;
	СтруктураПараметров.Вставить("П_КПП", СтрЗаменить(СтрокаСум, "-", ""));
	
	СтрокаСум = "";
	Для Инд = 1 По 3 Цикл 
		СтрокаСум = СтрокаСум + ПоказателиОтчета["Прил" + Инд];
	КонецЦикла;
	ОТ = Новый ОписаниеТипов("Число");
	СтруктураПараметров.Вставить("ПРИЛОЖЕНО_ЛИСТОВ", ОТ.ПривестиЗначение(СтрЗаменить(СтрокаСум, "-", "")));
	
	СтруктураПараметров.Вставить("UID", Новый УникальныйИдентификатор);
	СтруктураПараметров.Вставить("ОГРН", ПоказателиОтчета.ОГРН);
	СтруктураПараметров.Вставить("ОГРНИП", ПоказателиОтчета.ОГРНИП);
	СтруктураПараметров.Вставить("ДАТА_ПР", ПоказателиОтчета.ДатаПрекращенияДеятельности);
	СтруктураПараметров.Вставить("НАИМЕНОВАНИЕ_ОРГАНИЗАЦИИ", ПоказателиОтчета.НаимОрг);
	СтруктураПараметров.Вставить("ПРИЗНАК_НП_ПОДВАЛ", ПоказателиОтчета.ПрПодп);
	
	СтруктураПараметров.Вставить("ИНН_ПОДПИСАНТА", ПоказателиОтчета.ИННПодписанта);
	СтруктураПараметров.Вставить("EMAIL_ПОДПИСАНТА", ПоказателиОтчета.ЭлектроннаяПочтаПодписанта);
	СтруктураПараметров.Вставить("ТЕЛЕФОН", ПоказателиОтчета.ТелефонПодписанта);
	СтруктураПараметров.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПоказателиОтчета.ОргПодписант);
	СтруктураПараметров.Вставить("ДАТА_ПОДПИСИ", Выборка.ДатаПодписи);
	СтруктураПараметров.Вставить("ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ", ПоказателиОтчета.ДокУпПред);
	СтруктураПараметров.Вставить("ОРГ_ПРЕДСТАВИТЕЛЬ", ПоказателиОтчета.ОргУп);
	
	ТЗ = Новый ТаблицаЗначений;
	Для Каждого КЗ Из СтруктураПараметров Цикл 
		ТЗ.Колонки.Добавить(КЗ.Ключ);
	КонецЦикла;
	ТЗ0 = ТЗ.Добавить();
	ЗаполнитьЗначенияСвойств(ТЗ0, СтруктураПараметров);
	
	ДокОбъект.ДанныеУведомления = Новый ХранилищеЗначения(Новый Структура("Титульный, РегОтчет", ТЗ, Выборка.Ссылка));
	
КонецПроцедуры

Процедура СоздатьСконвертированныйТС2(Выборка) Экспорт 
	Попытка
		Если Не ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность.СообщенияВКонтролирующиеОрганы.КонвертацияОтчетовПриПереходеС82") Тогда
			Возврат;
		КонецЕсли;
		
		НачатьТранзакцию();
		НовоеУведомление = СоздатьНовыйТС2();
		ЗаполнитьДаннымиТС2(НовоеУведомление, Выборка);
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НовоеУведомление);
		
		РегОтчет = Выборка.Ссылка.ПолучитьОбъект();
		РегОтчет.Комментарий = "##УведомлениеОСпецрежимахНалогообложения##" + Выборка.Комментарий;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(РегОтчет);
		
		ЗаписьСоответствия = РегистрыСведений["СоответствиеРегОтчетовУведомлениям"].СоздатьМенеджерЗаписи();
		ЗаписьСоответствия.РегОтчет = РегОтчет;
		ЗаписьСоответствия.Прочитать();
		ЗаписьСоответствия.РегОтчет = РегОтчет;
		ЗаписьСоответствия.Уведомление = НовоеУведомление;
		ЗаписьСоответствия.Записать(Истина);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Ошибка = ИнформацияОбОшибке();
		СтрОш = НСтр("ru = 'Создание уведомления ТС-2'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(СтрОш, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
КонецПроцедуры

#КонецОбласти
#КонецЕсли