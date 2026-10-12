import { ToeicExamTemplatePage } from './app.po';

describe('ToeicExam App', function () {
    let page: ToeicExamTemplatePage;

    beforeEach(() => {
        page = new ToeicExamTemplatePage();
    });

    it('should display message saying app works', () => {
        page.navigateTo();
        expect(page.getParagraphText()).toEqual('app works!');
    });
});
