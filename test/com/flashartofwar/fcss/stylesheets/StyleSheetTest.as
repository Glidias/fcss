package com.flashartofwar.fcss.stylesheets
{
    import com.flashartofwar.fcss.styles.IStyle;
    import com.flashartofwar.fcss.styles.Style;
    import com.flashartofwar.fcss.utils.CSSTidyUtil;

    import org.flexunit.Assert;

    public class StyleSheetTest
    {

        private var sheet:FStyleSheet;

        public function StyleSheetTest()
        {
        }

        public static function get cssTextA():String
        {
            var xml:XML = <css>
                <![CDATA[/* This is a comment in the CSS file */
            @variables
            {
                    defaultColor: #333333;
                    }

            baseStyle {
                    x: 10;
                    y: 10;
                    width: 100px;
                    height: 100%;
                    padding: 5;
                    margin: 10;
                    }

            baseStyle .Button{
                    x: 0px;
                    y: 0px;
                    background-color: #000000;
                    }

            #playButton {
                    background-color: #FFFFFF;
                    background-image: url('/images/play_button_background.jpg');
                    }

            #playButton:over {
                    background-color: var(defaultColor);
                    }

            interactive {
                    cursor: hand;
                    }

            baseStyle interactive .SimpleButton
            {
                    width: 100;
                    height: 100;
                    }
            ]]>
            </css>;

            return xml.toString();
        }


        public static function get cssTextB():String
        {
            var xml:XML = <css><![CDATA[/* This is a comment in the CSS file */

                                        @variables
                                        {
                                                test2: FooBar;
                                                }

                                baseStyle {
                                        x: 300;
                                        height: 150px;
                                        margin: 0;
                                        }

                                extraStyle
                                {
                                        debug: true;
                                        }


                                ]]>
            </css>;
            return xml.toString();
        }

        [Before]

        public function runBeforeEveryTest():void
        {
            sheet = new FStyleSheet("sheetA");
            sheet.parseCSS(new CSSTidyUtil(cssTextA).toString());
        }

        [After]

        public function runAfterEveryTest():void
        {
            sheet.clear();
            sheet = null;
        }

        protected function praseSecondCSSSheet():void
        {
            sheet.parseCSS(new CSSTidyUtil(cssTextB).toString());
        }

        [Test]

        public function testClone():void
        {
            // Add your test logic here
            var clone:FStyleSheet = sheet.clone() as FStyleSheet;

            Assert.assertStrictlyEquals(sheet.toString(), clone.toString());
        }

        [Test]

        public function testGetstyle():void
        {
            var style:IStyle = sheet.getStyle("#playButton");
            var sampleTest:String = "#playButton{styleName:#playButton;background-color:#FFFFFF;background-image:url('/images/play_button_background.jpg');}";
            Assert.assertEquals(style.toString(), sampleTest);
        }

        [Test]

        public function testNewstyle():void
        {
            var prop:Style = new Style();
            prop.styleName = "teststyle";
            prop.x = "10";

            sheet.newStyle("teststyle", prop);

            Assert.assertEquals(sheet.getStyle("teststyle").toString(), prop.toString());
        }

        [Test]

        public function testParseCSS():void
        {
            var styles:Array = sheet.styleNames;
            var total:Number = styles.length;
            Assert.assertEquals(total, 7);
        }

        [Test]

        public function testSecondCSSParse():void
        {
            praseSecondCSSSheet();
            var styles:Array = sheet.styleNames;
            var total:Number = styles.length;
            Assert.assertEquals(total, 8);
        }

        [Test]

        public function testSecondCSSParseStyle():void
        {
            praseSecondCSSSheet();
            var style:IStyle = sheet.getStyle("baseStyle");
            var sampleTest:String = "baseStyle{styleName:baseStyle;x:300;y:10;width:100px;height:150px;padding:5;margin:0;}";
            Assert.assertEquals(style.toString(), sampleTest);
        }

        [Test]

        public function testToString():void
        {
            Assert.assertEquals(sheet.toString(), new CSSTidyUtil(cssTextA).toString());
        }

        [Test]

        public function testRelatedStyle():void
        {
            var totalRelated:int = sheet.relatedStyles(".SimpleButton").length;
            Assert.assertEquals(totalRelated, 2);
        }

        [Test]

        public function testHasStyle():void
        {
            Assert.assertTrue(sheet.hasStyle("baseStyle"));
        }

        [Test]

        public function testStyleNamesReturnsCleanArray():void
        {
            var styleNames:Array = sheet.styleNames;
            styleNames.length = 0;

            Assert.assertEquals(sheet.styleNames.length, 7);
        }

        [Test]

        public function testVaribleMerge():void
        {
            sheet.parseCSS(new CSSTidyUtil(cssTextB).toString());
            Assert.assertEquals(sheet.getStyle("@variables").toString(), "@variables{styleName:@variables;defaultColor:#333333;test2:FooBar;}");
        }

        [Test]

        public function testVariableReplace():void
        {
            var style:IStyle = sheet.getStyle("#playButton:over");
            Assert.assertEquals(style.toString(), "#playButton:over{styleName:#playButton:over;background-color:#333333;background-image:url('/images/play_button_background.jpg');}");
        }

        [Test]

        public function testNumberOfStylesAfterRequestingAllStyles():void
        {
            var i:int;
            var style:IStyle;
            var styles:Array = sheet.styleNames;
            var total:Number = styles.length;

            for (i = 0; i < total; i ++)
            {
                style = sheet.getStyle(sheet.styleNames[i]);
            }
            Assert.assertEquals(sheet.styleNames.length, total);
        }

        [Test]

        public function testRetainCSSUnitInformation():void
        {
            var style:Style = sheet.getStyle("baseStyle") as Style;
            Assert.assertEquals(style.width, "100px");
        }

        [Test]

        public function testStyleSheetReturnFromParse():void
        {
            var newSheet:FStyleSheet = new FStyleSheet();
            var returnedStyleSheet:FStyleSheet = newSheet.parseCSS(new CSSTidyUtil(cssTextA).toString()) as FStyleSheet;
            Assert.assertEquals(newSheet, returnedStyleSheet);
        }

        [Test]

        public function testSetStyleSheetName():void
        {
            sheet.name = "DemoStyleSheet";
            var returnedStyleSheet:FStyleSheet = sheet.parseCSS(new CSSTidyUtil(cssTextB).toString()) as FStyleSheet;

            Assert.assertEquals(sheet.name, returnedStyleSheet.name);
        }

        [Test]

        public function testDefaultStyleSheetName():void
        {
            Assert.assertEquals(sheet.name, "sheetA");
        }

        public function testClear():void
        {
            // Add your test logic here
            sheet.clear();
            Assert.assertEquals(sheet.toString(), "");
        }

        [Test]

        public function testClearStyleNames():void
        {
            // Add your test logic here
            sheet.clear();
            Assert.assertEquals(sheet.styleNames.length, 0);
        }

        [Test]
        public function testStyleLookup():void
        {
            var style:IStyle = sheet.styleLookup(".SimpleButton", false);
            var output:String = ".SimpleButton{styleName:.SimpleButton;width:100;height:100;}";
            Assert.assertEquals(style.toString(), output);
        }

        [Test]
        public function testRelatedStylesReturnEmptyErrorForUndefinedStyle():void
        {
            Assert.assertNotNull(sheet.relatedStyles("FooBar"));
        }

        [Test]
        public function testSingleMergeEmptyStyleDoesNotGetMerged():void
        {
            var style:IStyle = sheet.getStyle("baseStyle", ".FooBar");
            Assert.assertEquals(style.styleName, "baseStyle");
        }

        [Test]
        public function testMergeEmptyStyleDoesNotGetMerged():void
        {
            var style:IStyle = sheet.getStyle("baseStyle", "#playButton", ".FooBar");
            Assert.assertEquals(style.styleName, "#playButton");
        }

        [Test]
        public function testMergeEmptyPseudoSelectorDoesNotGetMerged():void
        {
            var style:IStyle = sheet.getStyle("baseStyle", ".FooBar:up");
            Assert.assertEquals(style.styleName, "baseStyle");
        }
    }
}

