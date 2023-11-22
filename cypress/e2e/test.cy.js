describe('User page', () => {
  beforeEach(function () {
    // "this" points at the test context object
    cy.fixture('kb_order')
      .then((kb_order) => {
        // "this" is still the test context object
        this.data = kb_order
      })
  })

  // the test callback is in "function () { ... }" form
  it('has user', function () {
    // this.user exists
    expect(this.data.OTP).to.equal('1234')
  })
})