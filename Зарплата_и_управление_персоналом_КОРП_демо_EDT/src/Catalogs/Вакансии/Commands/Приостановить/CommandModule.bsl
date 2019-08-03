
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПриостановитьНабор(ПараметрКоманды, НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса()));
	ОповеститьОбИзменении(Тип("СправочникСсылка.Вакансии"));
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.СостоянияВакансий"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриостановитьНабор(Вакансии, ДатаПриостановки)
	Справочники.Вакансии.ПриостановитьНабор(Вакансии, ДатаПриостановки);
КонецПроцедуры

#КонецОбласти
