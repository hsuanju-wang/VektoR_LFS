using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public GameObject cam;
    public float offset = 4;
    private bool isDelaying = false;
    private bool isMoving = false;
    public float delayTime = 0.5f;

    [Header("Position Movement")]
    public float moveSpeed = 1;
    public float moveLerpLimit = 0.1f;
    public float maxMovementAllowed = 0.1f;

    [Header("Rotation")]
    public float rotateSpeed = 2;
    public float rotateLerpLimit = 1;
    public float maxRotationAllowed = 10;
    private float currDelay = 0;
    private Quaternion prevRot;
    // Start is called before the first frame update
    void Start()
    {
        prevRot = cam.transform.rotation;
    }

    // Update is called once per frame
    void Update()
    {
        if ((Quaternion.Angle(cam.transform.rotation, prevRot) >= maxRotationAllowed ||
            Vector3.Distance(transform.position, offset * cam.transform.forward + cam.transform.position) >= maxMovementAllowed) &&
            !isMoving && !isDelaying)
        {
            isDelaying = true;
        }
        else if (isDelaying)
        {
            currDelay += Time.deltaTime;
            if (currDelay >= delayTime)
            {
                isMoving = true;
                isDelaying = false;
            }
        }
        else if (isMoving)
        {
            if (Quaternion.Angle(transform.rotation, cam.transform.rotation) <= rotateLerpLimit && 
                Vector3.Distance(transform.position, offset * transform.forward + cam.transform.position) <= moveLerpLimit)
            {
                isMoving = false;
                prevRot = transform.rotation;
            }
            else
            {
                transform.rotation = Quaternion.Lerp(transform.rotation, cam.transform.rotation, rotateSpeed*Time.deltaTime);
                //transform.rotation = Quaternion.Euler(Vector3.MoveTowards(transform.rotation.eulerAngles, cam.transform.rotation.eulerAngles, 1));
                transform.position = Vector3.Lerp(transform.position, offset * cam.transform.forward + cam.transform.position, moveSpeed*Time.deltaTime);
            }
        }
    }
}
