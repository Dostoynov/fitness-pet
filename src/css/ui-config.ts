type ViewBreakpoints = {
  desktop: number;
  tablet: number;
  min: number;
};

export const BREAKPOINTS: ViewBreakpoints = {
  desktop: 960,
  tablet: 768,
  min: 320,
};

export const TABLET_WIDTH_QUERY = `(max-width: ${BREAKPOINTS.desktop}px)`;
export const MOBILE_WIDTH_QUERY = `(max-width: ${BREAKPOINTS.tablet}px)`;
export const GTE_TABLET_WIDTH_QUERY = `(min-width: ${BREAKPOINTS.tablet}px)`;
