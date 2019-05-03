"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var protractor_1 = require("protractor");
var AgileMeterPage = /** @class */ (function () {
    function AgileMeterPage() {
    }
    AgileMeterPage.prototype.navigateTo = function () {
        return protractor_1.browser.get('/');
    };
    AgileMeterPage.prototype.getParagraphText = function () {
        return protractor_1.element(protractor_1.by.css('app-root h1')).getText();
    };
    return AgileMeterPage;
}());
exports.AgileMeterPage = AgileMeterPage;
//# sourceMappingURL=app.po.js.map