<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ADInfo.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="/Scripts/jquery-3.6.0.min.js"></script>
    <script src="/Scripts/handsontable/handsontable.full.min.js"></script>
    <script src="/Scripts/handsontable/ru-RU.js"></script>
    <link href="/Content/handsontable/handsontable.full.css" rel="stylesheet" />
    <style>
        .handsontable.as-you-type-demo tr:first-child th {
            vertical-align: bottom;
        }

        .handsontable.as-you-type-demo th > div.filterHeader {
            border-top: 1px solid #CCC;
        }

            .handsontable.as-you-type-demo th > div.filterHeader > input {
                width: calc(100% - 10px);
                box-shadow: none;
                border: 1px solid #CCC;
                margin-top: 1px;
            }
    </style>
    <script type="text/javascript"> 
        $(document).ready(function () {


            var container = document.getElementById('ADUsersTable');

            //Достаем данные
            function getData() {

                var result = null;
                $.ajax({
                    url: 'ADUsersGet.asmx/GetADUsers',
                    type: 'POST',
                    dataType: 'json',
                    async: false,
                    success: function (res) {
                        result = res;
                    }
                });

                return result;

            }

            //Поля для поиска
            var debounceFn = Handsontable.helper.debounce(function (colIndex, event) {
                var filtersPlugin = hot.getPlugin('filters');

                filtersPlugin.removeConditions(colIndex);
                filtersPlugin.addCondition(colIndex, 'contains', [event.target.value]);
                filtersPlugin.filter();
            }, 200);

            var addEventListeners = function (input, colIndex) {
                input.addEventListener('keydown', function (event) {
                    debounceFn(colIndex, event);
                });
            };

            // Build elements which will be displayed in header.
            var getInitializedElements = function (colIndex) {
                var div = document.createElement('div');
                var input = document.createElement('input');

                div.className = 'filterHeader';

                addEventListeners(input, colIndex);

                div.appendChild(input);

                return div;
            };

            // Add elements to header on `afterGetColHeader` hook.
            var addInput = function (col, TH) {
                // Hooks can return value other than number (for example `columnSorting` plugin use this).
                if (typeof col !== 'number') {
                    return col;
                }

                if (col >= 0 && TH.childElementCount < 2) {
                    TH.appendChild(getInitializedElements(col));
                }
            };

            // Deselect column after click on input.
            var doNotSelectColumn = function (event, coords) {
                if (coords.row === -1 && event.target.nodeName === 'INPUT') {
                    event.stopImmediatePropagation();
                    this.deselectCell();
                }
            };

            //Собственно таблица
            var hot = new Handsontable(container, {
                licenseKey: 'non-commercial-and-evaluation',
                language: 'ru-RU',
                data: getData(),
                startRows: 8,
                rowHeaders: true,
                colHeaders: true,
                className: 'as-you-type-demo',
                afterGetColHeader: addInput,
                beforeOnCellMouseDown: doNotSelectColumn,
                dropdownMenu: true,
                manualColumnMove: true,
                manualColumnResize: true,
                manualColumnFreeze: true,
                hiddenColumns: {
                    indicators: true
                },
                filters: true,
                dropdownMenu: ['filter_by_condition', 'filter_operators', 'filter_by_condition2', 'filter_by_value', 'filter_action_bar'],
                stretchH: 'all',
                contextMenu: true,
                readOnly: true,
                comments: false,
                persistentState: true,
                colHeaders: ['ФИО', 'Логин', 'Должность', 'Подразделение', 'Организация', 'Телефон', 'Мобильный', 'E-mail', 'Комната', 'Город', 'Табельный', 'Создано ЦСУПД', 'УЗ включена', 'Путь к УЗ', 'УЗ создана', 'Предупреждение', 'Запрет отправки', 'Запрет приема'],
                columnSorting: true,
                columns: [
                    {
                        data: 'FIO'
                    },
                    {
                        data: 'Account',
                    },
                    {
                        data: 'Title',
                    },
                    {
                        data: 'Department',
                    },
                    {
                        data: 'Organization',
                    },
                    {
                        data: 'PhoneNumber',
                    },
                    {
                        data: 'Mobilephone',
                    },
                    {
                        data: 'Mail',
                    },
                    {
                        data: 'Room',
                    },
                    {
                        data: 'City',
                    },
                    {
                        data: 'ID',
                    },
                    {
                        data: 'CSUPDCreated',
                    },
                    {
                        data: 'Enabled',
                    },
                    {
                        data: 'Path',
                    },
                    {
                        data: 'Created',
                        type: 'date',
                        dateFormat: 'DD.MM.YYYY',
                        correctFormat: true,
                    },
                    {
                        data: 'WarnQuota',
                        type: 'numeric'
                    },
                    {
                        data: 'SendQuota',
                        type: 'numeric'
                    },
                    {
                        data: 'ReceiveQuota',
                        type: 'numeric'
                    }
                ]
            });

            document.getElementById('Loading').parentNode.removeChild(document.getElementById('Loading'));

            //Кнопка экспорта
            var button1 = document.getElementById('export-file');
            var exportPlugin1 = hot.getPlugin('exportFile');

            
            button1.addEventListener('click', function () {
                exportPlugin1.downloadFile('csv', {
                    bom: true,
                    columnDelimiter: '\t',
                    columnHeaders: true,
                    exportHiddenColumns: false,
                    exportHiddenRows: false,
                    fileExtension: 'csv',
                    filename: 'Пользователи_[YYYY]-[MM]-[DD]',
                    mimeType: 'text/csv',
                    rowDelimiter: '\r\n',
                    rowHeaders: false
                });
            });

            //Меняем ширину выпадающего меню
            Handsontable.hooks.add('modifyColWidth', function (width, column) {
                if (this === hot.getPlugin('dropdownMenu').menu.hotMenu) {
                    if (column === 0) {
                        return 300;
                    }
                    return width;
                }

            })

            //Добавляем дефолтный фильтр не показывать отключенные УЗ
            filtersPlugin = hot.getPlugin('filters');
            filtersPlugin.addCondition(hot.propToCol('Enabled'), 'by_value', [['Да']]);
            filtersPlugin.filter();

            button1.style.visibility = "visible"

        });

    </script>
</head>
<body>
    <form id="form1" runat="server">

        <button id="export-file" class="intext-btn" style="visibility: hidden">Скачать в CSV</button>
        <div id="ADUsersTable"></div>
        <div id="Loading">Подождите, идёт загрузка...</div>

    </form>
</body>
</html>
