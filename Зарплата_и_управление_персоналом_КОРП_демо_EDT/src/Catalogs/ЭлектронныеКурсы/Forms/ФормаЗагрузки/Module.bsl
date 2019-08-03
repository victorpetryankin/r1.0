
#Область ОбработчикиСобытийФормы

// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если НЕ ВебКлиент Тогда		
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая Тогда
		КурсыНаКлиенте = Истина;
	КонецЕсли;		
	#КонецЕсли

	Элементы.ФормаНайтиКурсыВПапке.Видимость = КурсыНаКлиенте;
	УстановитьВидимостьПредупреждений();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ЭлектронныеКурсыЗагружатьПриИзменении(Элемент)
	УстановитьВидимостьПредупреждений();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыбратьАрхивСКурсами(Команда)	
	
	#Если ВебКлиент Тогда
		
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьАрхивСКурсамиВПродолжение", ЭтотОбъект);
	НачатьПомещениеФайла(ОписаниеОповещения,,, Истина, УникальныйИдентификатор);
	
	#Иначе
		
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьАрхивСКурсамиВТонкомКлиентеПродолжение", ЭтотОбъект);
	
	МассивТиповВыбора = Новый Массив;
	МассивТиповВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыЭлементовЭлектронныхРесурсов.Folder"));
	
	ДиалогВыбораФайлов = РазработкаЭлектронныхКурсовСлужебныйКлиент.ДиалогВыбораФайлаПоТипу(
		МассивТиповВыбора,
		НСтр("ru = 'Выберите архив с одним или несколькими курсами'"),
		НСтр("ru = 'Архив ZIP'")		
	);
	
	ДиалогВыбораФайлов.МножественныйВыбор = Ложь;
	ДиалогВыбораФайлов.Показать(ОписаниеОповещения);
	
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьАрхивСКурсамиВТонкомКлиентеПродолжение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт	

	#Если НЕ ВебКлиент Тогда

	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьАрхивСКурсамиВПродолжение", ЭтотОбъект);
	НачатьПомещениеФайла(ОписаниеОповещения,, ВыбранныеФайлы[0], Ложь, УникальныйИдентификатор);
	
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьАрхивСКурсамиВПродолжение(Результат, АдресФайла, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт

	Если НЕ Результат Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураИмениФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ВыбранноеИмяФайла);	
	Если НРег(СтруктураИмениФайла.Расширение) <> ".zip" Тогда
		ВызватьИсключение НСтр("ru = 'Загрузите файл zip'");
	КонецЕсли;	
	РазместитьАрхивZIPСКурсамиНаСервере(АдресФайла);	
	УстановитьВидимостьПредупреждений();
	
КонецПроцедуры

&НаСервере
Процедура РазместитьАрхивZIPСКурсамиНаСервере(АдресФайлаВоВременномХранилище)
	
	// Распаковываем архив с курсами
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаВоВременномХранилище);

	ИмяВременногоФайлаZIP = ПолучитьИмяВременногоФайла("zip");	
	ДвоичныеДанные.Записать(ИмяВременногоФайлаZIP);
	
	ПутьКВременномуКаталогуНаСервере = ПолучитьИмяВременногоФайла(""); // Реквизит формы
	СоздатьКаталог(ПутьКВременномуКаталогуНаСервере);	
	НоваяСтрока = ВременныеКаталоги.Добавить();
	НоваяСтрока.ПутьККаталогу = ПутьКВременномуКаталогуНаСервере;
	НоваяСтрока.ЭтоСервер = Истина;	
	ПутьКВременномуКаталогуНаСервере = ЭлектронноеОбучениеСлужебныйКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьКВременномуКаталогуНаСервере);	
	
	ФайлАрхива = Новый ЧтениеZIPФайла(ИмяВременногоФайлаZIP);
	ФайлАрхива.ИзвлечьВсе(ПутьКВременномуКаталогуНаСервере,  РежимВосстановленияПутейФайловZIP.Восстанавливать);
	ФайлАрхива.Закрыть();		
	
	ЭлектронноеОбучениеСлужебныйКлиентСервер.УдалитьВременныйФайл(ИмяВременногоФайлаZIP);
	
	// Получаем списки курсов из каталога с курсами
	
	СписокДоступныхКурсов = СписокДоступныхКурсовВКаталоге(ПутьКВременномуКаталогуНаСервере, ЭтотОбъект);	
	ЗаполнитьТаблицуКурсов(СписокДоступныхКурсов);	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВБазу(Команда)	
	
	ЕстьКурсыДляЗамены = Ложь;
	ЕстьКурсыДляЗаменыНовых = Ложь;
	
	ОпределитьЕстьЛиКурсыДляЗамены(ЕстьКурсыДляЗамены, ЕстьКурсыДляЗаменыНовых);
	
	Если ЕстьКурсыДляЗамены ИЛИ ЕстьКурсыДляЗаменыНовых Тогда		
		ТекстВопроса = ?(ЕстьКурсыДляЗаменыНовых, НСтр("ru = 'Заменить новые курсы в базе старыми с диска?'"), НСтр("ru = 'Заменить курсы в базе?'"));
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьВБазуПродолжение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);		
	Иначе
		ЗагрузитьВБазуОкончание();
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВБазуПродолжение(РезультатВопроса, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
	    Возврат;
	КонецЕсли;

	ЗагрузитьВБазуОкончание();    

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВБазуОкончание() Экспорт	
	
	Доступность = Ложь; // Блокируем все
	
	Состояние(НСтр("ru = 'Подождите, выполняется загрузка курсов. Это может занять длительное время.'"));
	КоличествоЗагруженных = ЗаписатьКурсыВБазу();
	
	Для каждого Строка Из ВременныеКаталоги Цикл	
		Если НЕ Строка.ЭтоСервер Тогда
			ЭлектронноеОбучениеСлужебныйКлиентСервер.УдалитьВременныйФайл(Строка.ПутьККаталогу);
		КонецЕсли;	
	КонецЦикла;	
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьВБазуПослеИнформирования", ЭтотОбъект);
	Если КоличествоЗагруженных > 0 Тогда
		Оповестить("ЭлектронныйКурсЗаписан");
		ПоказатьПредупреждение(ОписаниеОповещения, НСтр("ru = 'Загрузка завершена'"));
	Иначе
		ПоказатьПредупреждение(ОписаниеОповещения, НСтр("ru = 'Отсутствуют элементы для загрузки'"));
	КонецЕсли;    	
		
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВБазуПослеИнформирования(ДополнительныеПараметры) Экспорт	
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура НайтиКурсыВПапке(Команда)
	ВыбратьКаталогДляСКурсамиНаКлиенте();
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ВыбратьКаталогДляСКурсамиНаКлиенте()
	
	#Если НЕ ВебКлиент Тогда

	Если КурсыНаКлиенте Тогда
		
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите каталог для поиска в нем курсов'");
		
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			ПутьККаталогуСКурсами = ДиалогОткрытияФайла.Каталог;			
			ПутьККаталогуСКурсами = ЭлектронноеОбучениеСлужебныйКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьККаталогуСКурсами);
			ПослеВыбораКаталогаДляСКурсамиНаКлиенте(ПутьККаталогуСКурсами);
		КонецЕсли;		
		
	Иначе
		
		ВызватьИсключение НСТр("ru = 'Функциональность не поддерживается'");
		
	КонецЕсли;
	
	#КонецЕсли
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораКаталогаДляСКурсамиНаКлиенте(ПутьККаталогуСКурсами)

	СписокДоступныхКурсов = СписокДоступныхКурсовВКаталоге(ПутьККаталогуСКурсами, ЭтотОбъект);
	ЗаполнитьТаблицуКурсов(СписокДоступныхКурсов);
	УстановитьВидимостьПредупреждений();	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуКурсов(Знач СписокДоступныхКурсов)
	
	МассивЭлектронныхКурсовНаДиске = Новый Массив;
	Для каждого СвойстваКурса Из СписокДоступныхКурсов Цикл
		
		ЭлектронныйКурс = Справочники.ЭлектронныеКурсы.ПолучитьСсылку(Новый УникальныйИдентификатор(СвойстваКурса.Идентификатор));
		
		Если ЗначениеЗаполнено(ЭлектронныйКурс) И МассивЭлектронныхКурсовНаДиске.Найти(ЭлектронныйКурс) <> Неопределено Тогда
			ЭлектронныеКурсы.Очистить();
			ТекстСообщения =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Электронный курс ""%1"" доступен в нескольких экземплярах. Загрузка не может быть выполнена.'"), СвойстваКурса.Наименование);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;
		
		СвойстваКурсаВБазе = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭлектронныйКурс, "Ссылка, ДатаИзменения");
		
		НоваяСтрока = ЭлектронныеКурсы.Добавить();
		НоваяСтрока.Наименование = СвойстваКурса.Наименование;
		НоваяСтрока.ПутьКФайлуМанифеста = СвойстваКурса.ПутьКФайлуМанифеста;
		НоваяСтрока.ДатаИзмененияНаДиске = СвойстваКурса.ДатаИзменения;
		НоваяСтрока.ПутьККаталогу = СвойстваКурса.ПутьККаталогу;
		НоваяСтрока.Формат = СвойстваКурса.Формат;
		
		Если ЗначениеЗаполнено(СвойстваКурсаВБазе.Ссылка) Тогда
			НоваяСтрока.ЭлектронныйКурс = ЭлектронныйКурс;
			НоваяСтрока.ДатаИзмененияВБазе = СвойстваКурсаВБазе.ДатаИзменения;
		КонецЕсли;		
		
		Если НЕ ЗначениеЗаполнено(СвойстваКурсаВБазе.Ссылка) 
			ИЛИ (ЗначениеЗаполнено(СвойстваКурсаВБазе.Ссылка) 
			И СвойстваКурса.ДатаИзменения > СвойстваКурсаВБазе.ДатаИзменения) Тогда
			// Загружаем по умолчанию, если курса нет в базе или он более новый
			НоваяСтрока.Загружать = Истина;
		КонецЕсли;
		
		МассивЭлектронныхКурсовНаДиске.Добавить(ЭлектронныйКурс);
		
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
Функция СписокДоступныхКурсовВКаталоге(Знач ПутьККаталогу, Форма)
	
	#Если НЕ ВебКлиент Тогда
		
	ДоступныеКурсы = Новый Массив;
	
	// Ищем файлы манифеста с полными выгрузками курсов
	
	ФайлыМанифеста1С = НайтиФайлы(ПутьККаталогу, "v8course.json", Истина);
	
	Для каждого ФайлМанифеста Из ФайлыМанифеста1С Цикл
	
		Чтение = Новый ЧтениеJSON;
	    Чтение.ОткрытьФайл(ФайлМанифеста.ПолноеИмя);
		СтруктураМанифеста = ПрочитатьJSON(Чтение);
	    Чтение.Закрыть();			
		
		СвойстваКурса = ПустаяСтруктураСвойствКурса();		
		СвойстваКурса.Идентификатор = СтруктураМанифеста.UUID;
		СвойстваКурса.Наименование = СтруктураМанифеста.Title;
		СвойстваКурса.ДатаИзменения = ПрочитатьДатуJSON(СтруктураМанифеста.CourseModifiedDate.Value, ФорматДатыJSON.ISO);
		СвойстваКурса.ПутьКФайлуМанифеста = ФайлМанифеста.ПолноеИмя;
		СвойстваКурса.ПутьККаталогу = ФайлМанифеста.Путь;		
		СвойстваКурса.Формат = ПредопределенноеЗначение("Перечисление.ФорматыВыгрузкиЭлектронныхКурсов.ПолнаяКопия");		
				
		ДоступныеКурсы.Добавить(СвойстваКурса);
		
	КонецЦикла;
	
	// Ищем архивы zip с курсами SCORM
	
	ФайлыZIP = НайтиФайлы(ПутьККаталогу, "*.zip", Ложь);
	
	Для каждого ФайлZIP Из ФайлыZIP Цикл
		
		// Распаковываем пакет SCORM
		
		ФайлАрхива = Новый ЧтениеZIPФайла(ФайлZIP.ПолноеИмя);
		
		ЭлементМанифеста = ФайлАрхива.Элементы.Найти("imsmanifest.xml");
		
		Если ЭлементМанифеста = Неопределено Тогда
			ФайлАрхива.Закрыть();
			Продолжить; // Это не курс SCORM
		КонецЕсли;
		
		ПутьКВременномуКаталогу = ПолучитьИмяВременногоФайла("");
		СоздатьКаталог(ПутьКВременномуКаталогу);
		НоваяСтрока = Форма.ВременныеКаталоги.Добавить();
		НоваяСтрока.ПутьККаталогу = ПутьКВременномуКаталогу;
		#Если Сервер Тогда
		НоваяСтрока.ЭтоСервер = Истина;			
		#КонецЕсли
		ПутьКВременномуКаталогу = ЭлектронноеОбучениеСлужебныйКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьКВременномуКаталогу);
		
		ФайлАрхива.ИзвлечьВсе(ПутьКВременномуКаталогу,  РежимВосстановленияПутейФайловZIP.Восстанавливать);
		ФайлАрхива.Закрыть();
		
		// Получаем текст файла манифеста
		
		ПутьКФайлуМанифеста = ПутьКВременномуКаталогу + "imsmanifest.xml";				
		СвойстваКурса = СвойстваКурсаSCORM(ПутьКФайлуМанифеста); 
		
		Если СвойстваКурса <> Неопределено Тогда
			ДоступныеКурсы.Добавить(СвойстваКурса);
		КонецЕсли;
		
	КонецЦикла;
	
	// Ищем файлы imsmanifest.xml (без архива)
	
	ФайлыМанифестаSCORM = НайтиФайлы(ПутьККаталогу, "imsmanifest.xml", Истина);
	
	Для каждого ФайлМанифеста Из ФайлыМанифестаSCORM Цикл
		
		СвойстваКурса = СвойстваКурсаSCORM(ФайлМанифеста.ПолноеИмя);
		Если СвойстваКурса <> Неопределено Тогда
			ДоступныеКурсы.Добавить(СвойстваКурса);
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(ДоступныеКурсы);
	
	#КонецЕсли

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СвойстваКурсаSCORM(ПутьКФайлуМанифеста)
	
	ФайлМанифеста = Новый Файл(ПутьКФайлуМанифеста);
	
	Если НЕ ФайлМанифеста.Существует() Тогда
		ВызватьИсключение  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ru = 'Файл манифеста %1 не найден'", ПутьКФайлуМанифеста);
	КонецЕсли;
	
	ЧтениеТекста = Новый ЧтениеТекста(ПутьКФайлуМанифеста, КодировкаТекста.UTF8);
	ТекстФайлаМанифеста = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();					
	
	// Получаем свойства курсов из манифеста (по числу organizations)
	
	СвойстваКурса = СвойстваМанифестаSCORM(ТекстФайлаМанифеста);
	
	Если СвойстваКурса = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СвойстваКурса.ДатаИзменения = ФайлМанифеста.ПолучитьВремяИзменения();
	СвойстваКурса.ПутьКФайлуМанифеста = ПутьКФайлуМанифеста;
	СвойстваКурса.ПутьККаталогу = ФайлМанифеста.Путь;
	СвойстваКурса.Формат = ПредопределенноеЗначение("Перечисление.ФорматыВыгрузкиЭлектронныхКурсов.SCORM");
	
	Возврат СвойстваКурса;
	
КонецФункции

&НаСервереБезКонтекста 
Функция СвойстваМанифестаSCORM(Знач ТекстФайлаМанифеста)
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ТекстФайлаМанифеста);
		
	МанифестТип  = ФабрикаXDTO.Тип("http://www.imsglobal.org/xsd/imscp_v1p1", "manifestType");
	МанифестXDTO = ФабрикаXDTO.Создать(МанифестТип);
	
	Попытка
		МанифестXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, МанифестТип);
	Исключение
		ЭлектронноеОбучениеСлужебный.ЗаписатьОшибкуВЖурналРегистрации(НСТр("ru = 'Файл манифеста не соответствует стандарту SCORM 2004'"), ТекстФайлаМанифеста);
		Возврат Неопределено;
	КонецПопытки;
	
	СвойстваКурса = ПустаяСтруктураСвойствКурса();	
	
	ИдентификаторПакетаSCORM = МанифестXDTO.identifier;		
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторПакетаSCORM) Тогда
		ЭлектронноеОбучениеСлужебный.ЗаписатьОшибкуВЖурналРегистрации(НСТр("ru = 'Отсутствует идентификатор пакета SCORM'"), ТекстФайлаМанифеста);
		Возврат Неопределено;		
	КонецЕсли;
	
	Если МанифестXDTO.organizations.organization.Количество() = 0 Тогда
		
		ЭлектронноеОбучениеСлужебный.ЗаписатьОшибкуВЖурналРегистрации(НСТр("ru = 'Файл манифеста не содержит организацию контента'"), ТекстФайлаМанифеста);
		Возврат Неопределено;
		
	Иначе
		
		Для каждого Организация Из МанифестXDTO.organizations.organization Цикл
			
			ИдентификаторКурса = Организация.identifier;
			НаименованиеКурса = Организация.title;
			
			Прервать; // Только первая organization 
			
		КонецЦикла;	
		
	КонецЕсли;
	
	СуществующийЭлектронныйКурс = РегистрыСведений.ИмпортированныеЭлементыПакетаSCORM.РанееИмпортированныйЭлемент(ИдентификаторПакетаSCORM, "organization", ИдентификаторКурса);
	
	Если ЗначениеЗаполнено(СуществующийЭлектронныйКурс) Тогда
		СвойстваКурса.Идентификатор = Строка(СуществующийЭлектронныйКурс.УникальныйИдентификатор());
	Иначе
		СвойстваКурса.Идентификатор = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	КонецЕсли;
	
	СвойстваКурса.Наименование = НаименованиеКурса;	
	
	Возврат СвойстваКурса;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПустаяСтруктураСвойствКурса()
	Возврат Новый Структура("Идентификатор, Наименование, ДатаИзменения, ПутьКФайлуМанифеста, ПутьККаталогу, УдалитьПослеЗагрузки, Формат");
КонецФункции

&НаСервере
Функция ЗаписатьКурсыВБазу()
	
	КоличествоЗагруженных = 0;
	
	Для каждого Строка Из ЭлектронныеКурсы Цикл
	
		Если Строка.Загружать Тогда
		
			Если Строка.Формат = Перечисления.ФорматыВыгрузкиЭлектронныхКурсов.ПолнаяКопия Тогда
				РазработкаЭлектронныхКурсовСлужебный.ЗагрузитьВБазуПолныйПакет(Строка.ПутьКФайлуМанифеста, ЭтотОбъект.УникальныйИдентификатор);
			ИначеЕсли Строка.Формат = Перечисления.ФорматыВыгрузкиЭлектронныхКурсов.SCORM Тогда
				РазработкаЭлектронныхКурсовСлужебный.ЗагрузитьВБазуПакетSCORM(Строка.ПутьКФайлуМанифеста, ЭтотОбъект.УникальныйИдентификатор);
			Иначе
				ВызватьИсключение НСтр("ru = 'Неизвестный формат пакета'");
			КонецЕсли;		
			
			Строка.Загружено = Истина;
			КоличествоЗагруженных = КоличествоЗагруженных + 1;			
			
		КонецЕсли;			
		
	КонецЦикла;
	
	Для каждого Строка Из ВременныеКаталоги Цикл	
		Если Строка.ЭтоСервер Тогда
			ЭлектронноеОбучениеСлужебныйКлиентСервер.УдалитьВременныйФайл(Строка.ПутьККаталогу);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат КоличествоЗагруженных;
	
КонецФункции

&НаКлиенте
Процедура УстановитьВидимостьПредупреждений()
	
	ЕстьКурсыДляЗамены = Ложь;
	ЕстьКурсыДляЗаменыНовых = Ложь;
	
	ОпределитьЕстьЛиКурсыДляЗамены(ЕстьКурсыДляЗамены, ЕстьКурсыДляЗаменыНовых);
	
	Элементы.ГруппаПредупреждениеОЗаменеКурсов.Видимость = ЕстьКурсыДляЗамены И НЕ ЕстьКурсыДляЗаменыНовых;
	Элементы.ГруппаПредупреждениеОЗаменеНовыхКурсовСтарыми.Видимость = ЕстьКурсыДляЗамены И ЕстьКурсыДляЗаменыНовых;

КонецПроцедуры

&НаКлиенте
Процедура ОпределитьЕстьЛиКурсыДляЗамены(ЕстьКурсыДляЗамены, ЕстьКурсыДляЗаменыНовых)	
	
	ЕстьКурсыДляЗамены = Ложь;
	ЕстьКурсыДляЗаменыНовых = Ложь;
	
	Для каждого Строка Из ЭлектронныеКурсы Цикл
	
		Если НЕ Строка.Загружать Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.ДатаИзмененияВБазе) Тогда
			
			ЕстьКурсыДляЗамены = Истина;
			
			Если Строка.ДатаИзмененияНаДиске < Строка.ДатаИзмененияВБазе Тогда
				ЕстьКурсыДляЗаменыНовых = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры


#КонецОбласти

