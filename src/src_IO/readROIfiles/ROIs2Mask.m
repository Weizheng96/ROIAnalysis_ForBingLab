function [mbThisMask] = ROIs2Mask(sThisROI, vnImageSize)


   
switch (lower(sThisROI.strType))
  case 'rectangle'
        % - Make a rectangular mask
        mbThisMask = false(vnImageSize);
        sThisROI.vnRectBounds = sThisROI.vnRectBounds + 1;
        mbThisMask(sThisROI.vnRectBounds(1):sThisROI.vnRectBounds(3), sThisROI.vnRectBounds(2):sThisROI.vnRectBounds(4)) = true;
     
  case 'oval'
     % - Draw an oval inside the bounding box
     mbThisMask = ellipse2mask('bounds', vnImageSize, sThisROI.vnRectBounds+1);
     
  case {'polygon'; 'freehand'}
     % - Draw a polygonal mask
     mbThisMask = poly2mask(sThisROI.mnCoordinates(:, 1)+1, sThisROI.mnCoordinates(:, 2)+1, vnImageSize(1), vnImageSize(2));
     
  otherwise
     warning( 'ROIs2Regions:unsupported', ...
              '--- ROIs2Regions: Warning: Unsupported ROI type.');
end

end