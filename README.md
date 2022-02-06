<html xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:w="urn:schemas-microsoft-com:office:word"
xmlns="http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1251">
<meta name=ProgId content=Word.Document>
<meta name=Generator content="Microsoft Word 11">
<meta name=Originator content="Microsoft Word 11">
<link rel=File-List
href="PostgreSQL%20-%20кластер%20высокой%20доступности.files/filelist.xml">
<title>Введение</title>
<!--[if gte mso 9]><xml>
 <o:DocumentProperties>
  <o:Author>Visitor</o:Author>
  <o:LastAuthor>Visitor</o:LastAuthor>
  <o:Revision>2</o:Revision>
  <o:TotalTime>206</o:TotalTime>
  <o:Created>2022-02-06T11:20:00Z</o:Created>
  <o:LastSaved>2022-02-06T11:20:00Z</o:LastSaved>
  <o:Pages>1</o:Pages>
  <o:Words>1331</o:Words>
  <o:Characters>7591</o:Characters>
  <o:Company>Home</o:Company>
  <o:Lines>63</o:Lines>
  <o:Paragraphs>17</o:Paragraphs>
  <o:CharactersWithSpaces>8905</o:CharactersWithSpaces>
  <o:Version>11.9999</o:Version>
 </o:DocumentProperties>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:PunctuationKerning/>
  <w:ValidateAgainstSchemas/>
  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
  <w:IgnoreMixedContent>false</w:IgnoreMixedContent>
  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
  <w:Compatibility>
   <w:BreakWrappedTables/>
   <w:SnapToGridInCell/>
   <w:WrapTextWithPunct/>
   <w:UseAsianBreakRules/>
   <w:DontGrowAutofit/>
  </w:Compatibility>
  <w:BrowserLevel>MicrosoftInternetExplorer4</w:BrowserLevel>
 </w:WordDocument>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:LatentStyles DefLockedState="false" LatentStyleCount="156">
 </w:LatentStyles>
</xml><![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;
	mso-font-charset:2;
	mso-generic-font-family:auto;
	mso-font-pitch:variable;
	mso-font-signature:0 268435456 0 0 -2147483648 0;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;
	mso-font-charset:204;
	mso-generic-font-family:swiss;
	mso-font-pitch:variable;
	mso-font-signature:-469745921 -1073732485 9 0 511 0;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-parent:"";
	margin:0cm;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;
	text-underline:single;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;
	text-underline:single;}
p
	{mso-margin-top-alt:auto;
	margin-right:0cm;
	mso-margin-bottom-alt:auto;
	margin-left:0cm;
	mso-pagination:widow-orphan;
	font-size:12.0pt;
	font-family:"Times New Roman";
	mso-fareast-font-family:"Times New Roman";}
span.term
	{mso-style-name:term;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:2.0cm 42.55pt 2.0cm 42.55pt;
	mso-header-margin:35.45pt;
	mso-footer-margin:35.45pt;
	mso-paper-source:0;}
div.Section1
	{page:Section1;}
 /* List Definitions */
 @list l0
	{mso-list-id:441875705;
	mso-list-template-ids:-884460392;}
@list l0:level1
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:36.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:Symbol;}
@list l0:level2
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:72.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	mso-ansi-font-size:10.0pt;
	font-family:"Courier New";
	mso-bidi-font-family:"Times New Roman";}
@list l1
	{mso-list-id:1472942653;
	mso-list-type:hybrid;
	mso-list-template-ids:2074783640 68747265 68747267 68747269 68747265 68747267 68747269 68747265 68747267 68747269;}
@list l1:level1
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:36.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;
	font-family:Symbol;}
ol
	{margin-bottom:0cm;}
ul
	{margin-bottom:0cm;}
-->
</style>
<!--[if gte mso 10]>
<style>
 /* Style Definitions */
 table.MsoNormalTable
	{mso-style-name:"Обычная таблица";
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	mso-style-noshow:yes;
	mso-style-parent:"";
	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;
	mso-para-margin:0cm;
	mso-para-margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:10.0pt;
	font-family:"Times New Roman";
	mso-ansi-language:#0400;
	mso-fareast-language:#0400;
	mso-bidi-language:#0400;}
</style>
<![endif]-->
</head>

<body lang=RU link=blue vlink=purple style='tab-interval:35.4pt'>

<div class=Section1>

<p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span
style='mso-bidi-font-size:10.0pt;font-family:Calibri'>Кластер PostgreSQL
высокой доступности без потери транзакций и с защитой от split-brain.<o:p></o:p></span></b></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'>Замечание<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'>Понятие кластеризации несколько шире (см <a
href="https://gitlab.com/gitlab-com/gl-infra/infrastructure/-/issues/7282">https://gitlab.com/gitlab-com/gl-infra/infrastructure/-/issues/7282</a>)</span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'><o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:70.8pt'><span style='font-size:10.0pt;
font-family:Calibri'>Можно ли быть недоступным в течение определенных периодов
времени или лучше быть (почти) всегда доступным, терпя при этом определенную
потерю данных?<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:70.8pt'><span style='font-size:10.0pt;
font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:70.8pt'><span style='font-size:10.0pt;
font-family:Calibri'>PostgreSQL поддерживает три возможных компромисса между
согласованностью (C) и доступностью (A):<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:70.8pt'><span style='font-size:10.0pt;
font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:70.8pt'><b style='mso-bidi-font-weight:
normal'><span style='font-size:10.0pt;font-family:Calibri'>Асинхронный.</span></b><span
style='font-size:10.0pt;font-family:Calibri'> Предпочитает </span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>A</span><span
style='font-size:10.0pt;font-family:Calibri'>, а не </span><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>C</span><span
style='font-size:10.0pt;font-family:Calibri'>. Это наиболее часто используемый
режим. Наиболее нетребовательный к ресурсам. Предполагает наличие минимум 2-х
узлов.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:70.8pt'><b style='mso-bidi-font-weight:
normal'><span style='font-size:10.0pt;font-family:Calibri'>Синхронный.</span></b><span
style='font-size:10.0pt;font-family:Calibri'> Предпочитает </span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>C</span><span
style='font-size:10.0pt;font-family:Calibri'>, а не </span><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>A</span><span
style='font-size:10.0pt;font-family:Calibri'>. Доступность ниже, чем на одном узле.
Любой отказавший синхронный узел вызывает недоступность кластера до тех пор,
пока он не вернется в исходное состояние или не будет заменен. Из-за этого это
редко применяется. Предполагает наличие минимум 2-х узлов.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:70.8pt'><b style='mso-bidi-font-weight:
normal'><span style='font-size:10.0pt;font-family:Calibri'>Полусинхронный.</span></b><span
style='font-size:10.0pt;font-family:Calibri'> Некоторые узлы синхронны,
остальные асинхронны. Предполагает наличие минимум 3-х узлов.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'>Выбор кластеризации определяется в первую очередь
бизнесом.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'>Далее
рассматривается построение кластера PostgreSQL высокой доступности без потери
закоммиченных данных (предпочтение согласованности) и с защитой от split-brain.<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'><a
href="https://en.wikipedia.org/wiki/Split-brain_(computing)">https://en.wikipedia.org/wiki/Split-brain_(computing)</a><o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'>Современные коммерческие кластеры высокой доступности
общего назначения обычно используют комбинацию пульса (heartbeat) между узлами
кластера и хранилища-свидетеля кворума (</span><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>quorum</span><span
style='font-size:10.0pt;font-family:Calibri'>). Проблема с двухузловыми
кластерами заключается в том, что добавление устройства-свидетеля увеличивает
стоимость и сложность (даже если оно реализовано в облаке), но без него в
случае сбоя heartbeat члены кластера не могут определить, какое из них должно
быть активным. В таких кластерах (без кворума) в случае сбоя члена, даже если
члены имеют первичный и вторичный статус, существует по крайней мере 50%
вероятность того, что кластер высокой доступности с 2 узлами полностью выйдет
из строя, пока не будет обеспечено вмешательство человека, чтобы предотвратить
активацию нескольких членов независимо друг от друга и, следовательно, несоответствие
или повреждение данных.<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span
style='font-size:13.0pt;mso-bidi-font-size:10.0pt;font-family:Calibri'>Введение<o:p></o:p></span></b></p>

<p style='margin-top:7.5pt;margin-right:0cm;margin-bottom:0cm;margin-left:0cm;
margin-bottom:.0001pt'><span style='font-size:10.0pt;font-family:Calibri'>Разница
между отказоустойчивостью и высокой доступностью заключается в том, что
отказоустойчивая среда не имеет прерывания обслуживания, но имеет значительно
более высокую стоимость, тогда как&nbsp;<strong><span style='font-family:Calibri'>среда
высокой доступности имеет минимальное прерывание обслуживания</span></strong>.<o:p></o:p></span></p>

<p style='margin-top:7.5pt;margin-right:0cm;margin-bottom:0cm;margin-left:0cm;
margin-bottom:.0001pt'><span style='font-size:10.0pt;font-family:Calibri'>Термин
&quot;<strong><span style='font-family:Calibri'>минимальное прерывание
обслуживания</span></strong>&quot; понятие растяжимое, поэтому рассматривались
все варианты реализации высокой доступности, начиная с простого бэкапирования.<o:p></o:p></span></p>

<p style='margin-top:7.5pt;margin-right:0cm;margin-bottom:0cm;margin-left:0cm;
margin-bottom:.0001pt'><span style='font-size:10.0pt;font-family:Calibri'>1.&nbsp;Непрерывное
архивирование и восстановление на момент времени (Point-in-Time Recovery,
PITR)&nbsp;<a
href="https://postgrespro.ru/docs/postgresql/10/continuous-archiving"><span
style='color:#0052CC'>https://postgrespro.ru/docs/postgresql/10/continuous-archiving</span></a><o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'>2.&nbsp;В
документации PostgreSQL есть описание и краткое сравнение&nbsp;различных
решений высокой доступности&nbsp;<a
href="https://postgrespro.ru/docs/postgresql/10/different-replication-solutions"><span
style='color:#0052CC'>https://postgrespro.ru/docs/postgresql/10/different-replication-solutions</span></a><o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<ul style='margin-top:0cm' type=disc>
 <li class=MsoNormal style='color:#212529;mso-list:l1 level1 lfo2;tab-stops:
     list 36.0pt;background:white'><span class=term><span style='font-size:
     10.0pt;font-family:Calibri'>Отказоустойчивость на разделяемых дисках</span></span><span
     style='font-size:10.0pt;font-family:Calibri'><o:p></o:p></span></li>
 <li class=MsoNormal style='color:#212529;mso-list:l1 level1 lfo2;tab-stops:
     list 36.0pt;background:white'><span class=term><span style='font-size:
     10.0pt;font-family:Calibri'>Репликация на уровне файловой системы (блочного
     устройства)</span></span><span style='font-size:10.0pt;font-family:Calibri'><o:p></o:p></span></li>
 <li class=MsoNormal style='color:#212529;mso-list:l1 level1 lfo2;tab-stops:
     list 36.0pt;background:white'><span class=term><span style='font-size:
     10.0pt;font-family:Calibri'>Трансляция</span></span><span class=term><span
     style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'> </span></span><span
     class=term><span style='font-size:10.0pt;font-family:Calibri'>журнала</span></span><span
     class=term><span style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:
     EN-US'> </span></span><span class=term><span style='font-size:10.0pt;
     font-family:Calibri'>предзаписи</span></span><span lang=EN-US
     style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'><o:p></o:p></span></li>
 <li class=MsoNormal style='color:#212529;mso-list:l1 level1 lfo2;tab-stops:
     list 36.0pt;background:white'><span class=term><span lang=EN-US
     style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>…</span></span><span
     lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:
     EN-US'><o:p></o:p></span></li>
 <li class=MsoNormal style='color:#212529;mso-list:l1 level1 lfo2;tab-stops:
     list 36.0pt;background:white'><span class=term><span style='font-size:
     10.0pt;font-family:Calibri'>Асинхронная</span></span><span class=term><span
     style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'> </span></span><span
     class=term><span style='font-size:10.0pt;font-family:Calibri'>репликация</span></span><span
     lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:
     EN-US'><o:p></o:p></span></li>
 <li class=MsoNormal style='color:#212529;mso-list:l1 level1 lfo2;tab-stops:
     list 36.0pt;background:white'><span class=term><span style='font-size:
     10.0pt;font-family:Calibri'>Синхронная</span></span><span class=term><span
     style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'> </span></span><span
     class=term><span style='font-size:10.0pt;font-family:Calibri'>репликация</span></span><span
     lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:
     EN-US'><o:p></o:p></span></li>
</ul>

<p class=MsoNormal><span lang=EN-US style='font-size:10.0pt;font-family:Calibri;
mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'>В
результате поисков в Интернет были отброшены практически все описанные варианты
(либо из-за потери транзакций, либо из-за отсутствия надёжной и простой защиты
от split-brain, либо из-за того и другого одновременно).<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'>Единственный
вариант, который обладает и защитой от потери закоммиченных транзакций, и
защитой от split-brain, это <b style='mso-bidi-font-weight:normal'>синхронная
репликация в режиме кворума</b>.<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><a
href="https://postgrespro.ru/docs/postgresql/10/runtime-config-replication#GUC-SYNCHRONOUS-STANDBY-NAMES">https://postgrespro.ru/docs/postgresql/10/runtime-config-replication#GUC-SYNCHRONOUS-STANDBY-NAMES</a><o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>synchronous_standby_names</span></b><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>:
'ANY 1 (&quot;pg-1&quot;,&quot;pg-2&quot;,&quot;pg-3&quot;)'<o:p></o:p></span></p>

<p class=MsoNormal><span lang=EN-US style='font-size:10.0pt;font-family:Calibri;
mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'>- синхронная
потоковая репликацию на основе кворума, когда транзакции фиксируются только
после того, как их записи в WAL реплицируются как минимум на 1 из ведомых
серверов (кворум 2 из 3-х).<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'>В данной
конфигурации невозможен split-brain. Даже если два сервера объявят себя master,
то работать сможет только один из них, т.к. для фиксации транзакции нужен ещё и
slave, а slave будет работать только с одним master (определяется timeline <a
href="https://habr.com/ru/company/pgdayrussia/blog/327750/">https://habr.com/ru/company/pgdayrussia/blog/327750/</a>).<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'>Данная
конфигурация позволяет перезагружать/останавливать/обслуживать любой узел с postgres
не прерывая работы кластера.<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'>Замечание<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'>Также является важным параметр <b style='mso-bidi-font-weight:
normal'>synchronous_commit<o:p></o:p></b></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'><a
href="https://www.enterprisedb.com/blog/why-use-synchronous-replication-in-postgresql-configure-streaming-replication-wal">https://www.enterprisedb.com/blog/why-use-synchronous-replication-in-postgresql-configure-streaming-replication-wal</a><o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'>Когда произошел сбой, транзакции, которые находились на
пути от walsender к процессу walreceiver, были потеряны.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'>Минимальные требования: <b style='mso-bidi-font-weight:
normal'>synchronous_commit = on</b><o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'><a
href="https://postgrespro.ru/docs/postgresql/10/runtime-config-wal#GUC-SYNCHRONOUS-COMMIT">https://postgrespro.ru/docs/postgresql/10/runtime-config-wal#GUC-SYNCHRONOUS-COMMIT</a><o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'><a
href="https://www.2ndquadrant.com/en/blog/evolution-fault-tolerance-postgresql-synchronous-commit/">https://www.2ndquadrant.com/en/blog/evolution-fault-tolerance-postgresql-synchronous-commit/</a><o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><b style='mso-bidi-font-weight:
normal'><span style='font-size:10.0pt;font-family:Calibri'>synchronous_commit =
off</span></b><span style='font-size:10.0pt;font-family:Calibri'> - коммиты
отправляются в приложение, после того как транзакция обрабатывается внутренним
процессом, но до того, как транзакция сброшена в WAL. Это означает, что даже
один сервер гипотетически может потерять данные. Сама репликация игнорируется.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><b style='mso-bidi-font-weight:
normal'><span style='font-size:10.0pt;font-family:Calibri'>synchronous_commit =
local</span></b><span style='font-size:10.0pt;font-family:Calibri'> - коммиты
отправляются в приложение, как только данные сбрасываются в WAL на первичный
узле. Сама репликация игнорируется. Думайте об этом, как смеси между
выключенным и включенным, где он обеспечивает локальные WAL, игнорируя согласованность
реплик.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><b style='mso-bidi-font-weight:
normal'><span style='font-size:10.0pt;font-family:Calibri'>synchronous_commit =
remote_write</span></b><span style='font-size:10.0pt;font-family:Calibri'> -
write коммиты отправляются в приложение после того, как операционная система
резервных серверов, определенных в synchronous_standby_names, отправит
подтверждение транзакций, отправленных основным Walsender. Это продвигает нас
на шаг вперед.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><b style='mso-bidi-font-weight:
normal'><span style='font-size:10.0pt;font-family:Calibri'>synchronous_commit =
on</span></b><span style='font-size:10.0pt;font-family:Calibri'> - коммиты
отправляются в приложение, как только данные сбрасываются в WAL. Это применимо
как к основному серверу в конфигурации с одним сервером, так и к резервным
серверам при потоковой репликации. На самом деле это на один шаг дальше, чем
remote_write, поскольку он обеспечивает фиксацию только после того, как он
попал в резервный WAL.<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><b style='mso-bidi-font-weight:
normal'><span style='font-size:10.0pt;font-family:Calibri'>synchronous_commit =
remote_apply</span></b><span style='font-size:10.0pt;font-family:Calibri'> -
подтверждение отправляет в приложение только после того, как резервные серверы,
включенные в synchronous_standby_names, подтверждают, что транзакции были
применены за пределами WAL к самой базе данных.<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><b style='mso-bidi-font-weight:
normal'><span style='font-size:10.0pt;font-family:Calibri'>о производительности
репликации<o:p></o:p></span></b></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'><span style='mso-spacerun:yes'> </span><a
href="https://www.cybertec-postgresql.com/en/the-synchronous_commit-parameter/">https://www.cybertec-postgresql.com/en/the-synchronous_commit-parameter/</a><o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'>&quot;</span><span lang=EN-US style='font-size:10.0pt;
font-family:Calibri;mso-ansi-language:EN-US'>async</span><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri'> </span><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>on</span><span
style='font-size:10.0pt;font-family:Calibri'>&quot; - 4256 </span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>TPS</span><span
style='font-size:10.0pt;font-family:Calibri'> (здесь 1 транзакция означает 3
обновления, 1 вставку, 1 выбор)<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'>&quot;</span><span lang=EN-US style='font-size:10.0pt;
font-family:Calibri;mso-ansi-language:EN-US'>async</span><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri'> </span><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>off</span><span
style='font-size:10.0pt;font-family:Calibri'>&quot; - 6211 </span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>TPS</span><span
style='font-size:10.0pt;font-family:Calibri'> (+45% по сравнению с &quot;</span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>async</span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri'> </span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>on</span><span
style='font-size:10.0pt;font-family:Calibri'>&quot;)<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span style='font-size:10.0pt;
font-family:Calibri'>&quot;</span><span lang=EN-US style='font-size:10.0pt;
font-family:Calibri;mso-ansi-language:EN-US'>sync</span><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri'> </span><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>on</span><span
style='font-size:10.0pt;font-family:Calibri'>&quot; - 3329 </span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>TPS</span><span
style='font-size:10.0pt;font-family:Calibri'> (-22% по сравнению со значением
по умолчанию </span><span lang=EN-US style='font-size:10.0pt;font-family:Calibri;
mso-ansi-language:EN-US'>&quot;async on&quot;)<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>&quot;sync
remote_write&quot; - 3720 TPS (+12% по сравнению с &quot;sync on&quot;)<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:35.4pt'><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>&quot;sync
remote_apply&quot; - 3055 TPS (-8% по сравнению с &quot;sync on&quot;)<o:p></o:p></span></p>

<p class=MsoNormal><span lang=EN-US style='font-size:10.0pt;font-family:Calibri;
mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'>Для
построения кластера также требуется определить единую точку входа. Проще всего
это обеспечить через </span><span lang=EN-US style='font-size:10.0pt;
font-family:Calibri;mso-ansi-language:EN-US'>Cluster</span><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri'> </span><span style='font-size:
10.0pt;font-family:Calibri'>IP.<o:p></o:p></span></p>

<p class=MsoNormal><span lang=EN-US style='font-size:10.0pt;font-family:Calibri;
mso-ansi-language:EN-US'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'>Вышеперечисленного
достаточно, чтобы вручную построить кластер.<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'>Для
автоматической работы кластера требуется выполнение дополнительных действий: определение,
в случае падения master, кто станет следующим master, а так же выполнение
операций по перенастройке PostgreSQL на узлах, промоут роли в кластере,
синхронизация реплики и запуск PostgreSQL. Всё это выливается в достаточно
внушительный список операций.<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'>Для выполнения
всего перечисленного предпочтительнее использовать </span><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>Patroni</span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri'> </span><span
style='font-size:10.0pt;font-family:Calibri'>(<a
href="https://github.com/zalando/patroni">https://github.com/zalando/patroni</a>)
- оркестратор работы высокодоступного кластера PostgreSQL (</span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>PostgreSQL</span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri'> </span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>High</span><span
style='font-size:10.0pt;font-family:Calibri'>-</span><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>Available</span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri'> </span><span
style='font-size:10.0pt;font-family:Calibri'>O</span><span lang=EN-US
style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>rchestrator</span><span
style='font-size:10.0pt;font-family:Calibri'>)<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'>Учитывая
наличие в Patroni callback скриптов, достаточно просто реализовать </span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>Cluster</span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri'> </span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>IP</span><span
style='font-size:10.0pt;font-family:Calibri'>.<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><a
href="https://patroni.readthedocs.io/en/latest/SETTINGS.html?highlight=callback">https://patroni.readthedocs.io/en/latest/SETTINGS.html?highlight=callback</a><o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'>Для работы
</span><span lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:
EN-US'>C</span><span style='font-size:10.0pt;font-family:Calibri'>luster </span><span
lang=EN-US style='font-size:10.0pt;font-family:Calibri;mso-ansi-language:EN-US'>IP</span><span
style='font-size:10.0pt;font-family:Calibri'> в сегментированных корпоративных сетях
используется ARP </span><span lang=EN-US style='font-size:10.0pt;font-family:
Calibri;mso-ansi-language:EN-US'>a</span><span style='font-size:10.0pt;
font-family:Calibri'>nnouncements <a
href="https://en.wikipedia.org/wiki/Address_Resolution_Protocol#ARP_announcements">https://en.wikipedia.org/wiki/Address_Resolution_Protocol#ARP_announcements</a>
(используется pgpool).<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:10.0pt;font-family:Calibri'><o:p>&nbsp;</o:p></span></p>

</div>

</body>

</html>
