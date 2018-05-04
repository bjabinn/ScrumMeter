import { ScrumMeterPage } from './app.po';

describe('scrum-meter App', function() {
  let page: ScrumMeterPage;

  beforeEach(() => {
    page = new ScrumMeterPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
