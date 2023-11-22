describe("KB_TS-01-TC-01 Verify that user is able to order with valid credentials.", () => {
  beforeEach(function () {
    cy.fixture("kb_order").then((kb_order) => {
      this.data = kb_order;
    });
  });
  it("Checking the orders section on the home page", function () {
    let card_count = this.data.en.main_page.card_count;
    cy.visit("/");
    // Check url path
    cy.url("https://www.kapitalbank.az/en");
    cy.title(this.data.title);
    // 1. Find the order list section and click "next", "back" button
    let itemListInOrder =
      ".slick-current > :nth-child(1) > .cards-section__slider__item > .cards-section__bottom > .container > .cards-section__arrows > .fa-chevron-";
    let itemListInOrderArr = ["right", "left"];
    itemListInOrderArr.forEach(function (e) {
      for (let n = 0; n < card_count; n++) {
        cy.get(itemListInOrder + e).click();
      }
    });
    // 2. Check the number of cards in the order list
    cy.get(".cards-section__slider > .slick-list")
      .find(".slick-slide")
      .should("have.length", card_count);
    // 3. Check the title on the title page of each card
    let cardListHeaderCSS =
      ".slick-current > :nth-child(1) > .cards-section__slider__item > .cards-section__top > .container > ";
    cy.get(cardListHeaderCSS + ".section-title").should(
      "have.text",
      this.data.en.main_page.card_list[0].BRCB_BLACK.cards_section__top
        .container.h1_text
    );
    // 4. Check the description of each card in the title section
    cy.get(cardListHeaderCSS + "p").should(
      "have.text",
      this.data.en.main_page.card_list[0].BRCB_BLACK.cards_section__top
        .container.p
    );

    let cardListFooterCSS =
      ".slick-current > :nth-child(1) > .cards-section__slider__item > .cards-section__bottom > .container > ";
    let liCountInOrderFooter =
      this.data.en.main_page.card_list[0].BRCB_BLACK.cards_section__bottom.li
        .li_count;
    cy.get(cardListFooterCSS)
      .find("li")
      .should("have.length", liCountInOrderFooter);
    // 5. Check the type in the title part of each card
    // 6. Check the price of each card in the name section
    // 7. Check the expiration date of each card on the title page
    for (let n = 0; n < liCountInOrderFooter; n++) {
      cy.get(
        cardListFooterCSS + "ul > :nth-child(" + (n + 1) + ") > span"
      ).should(
        "have.text",
        this.data.en.main_page.card_list[0].BRCB_BLACK.cards_section__bottom.li
          .li_text[n].span
      );
      cy.get(cardListFooterCSS + "ul > :nth-child(" + (n + 1) + ")").contains(
        this.data.en.main_page.card_list[0].BRCB_BLACK.cards_section__bottom.li
          .li_text[n].text
      );
    }
    // 8. Check the image of each card in the title section
    cy.get(cardListFooterCSS + ".cards-section__image > img")
      .should("have.attr", "src")
      .should(
        "include",
        this.data.en.main_page.card_list[0].BRCB_BLACK.cards_section__bottom.img
      );
    // 9. Check the operation of the button on the name part of each card
    cy.get(cardListFooterCSS + ".btn")
      .should("have.attr", "href")
      .and("include", "BRCB_BLACK") //&amp;tvr_id=
      .then((href) => {
        // 10. Visit url
        cy.visit(href);

        cy.title('Loan');
      });
  });
});
