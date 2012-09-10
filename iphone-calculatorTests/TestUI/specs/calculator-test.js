describe("IphoneAmazonCalculator", function() {
 	var target = UIATarget.localTarget();
 	var mainWindow = target.frontMostApp().mainWindow();

	it("display should show zero", function() {
       var display = mainWindow.elements()["display"];
       
       expect("0").toBe(display.value());
		
	});
         
    it("twelve plus three equal fithteen", function() {
       var display = mainWindow.elements()["display"];
       var buttons = mainWindow.buttons();
              
       buttons.firstWithName("C").tap();       
       buttons.firstWithName("1").tap();
       buttons.firstWithName("2").tap();
       buttons.firstWithName("+").tap();
       buttons.firstWithName("3").tap();
       buttons.firstWithName("=").tap();
       
       target.delay(1);
       
       expect("15").toBe(display.value());    
    });

     it("two minus one equal one", function() {
        var display = mainWindow.elements()["display"];
        var buttons = mainWindow.buttons();
        
        buttons.firstWithName("C").tap();
        
        buttons.firstWithName("2").tap();
        buttons.firstWithName("-").tap();
        buttons.firstWithName("1").tap();
        buttons.firstWithName("=").tap();
        
        target.delay(1);
        
        expect("1").toBe(display.value());
        });

     it("eight divide four equal two", function() {
        var display = mainWindow.elements()["display"];
        var buttons = mainWindow.buttons();
        
        buttons.firstWithName("C").tap();
        
        buttons.firstWithName("8").tap();
        buttons.firstWithName("/").tap();
        buttons.firstWithName("4").tap();
        buttons.firstWithName("=").tap();
        
        target.delay(1);
        
        expect("2").toBe(display.value());
        });

     it("ten multiple two equal twenty", function() {
        var display = mainWindow.elements()["display"];
        var buttons = mainWindow.buttons();
        
        buttons.firstWithName("C").tap();
        
        buttons.firstWithName("1").tap();
        buttons.firstWithName("0").tap();
        buttons.firstWithName("*").tap();
        buttons.firstWithName("2").tap();
        buttons.firstWithName("=").tap();
        
        target.delay(1);
        
        expect("20").toBe(display.value());
        });
});